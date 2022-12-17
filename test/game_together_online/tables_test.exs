defmodule GameTogetherOnline.TablesTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.TablesFixtures
  alias GameTogetherOnline.Tables
  alias GameTogetherOnline.Tables.Updates
  alias GameTogetherOnline.Tables.Presence
  alias GameTogetherOnline.Administration
  alias Ecto.UUID

  import GameTogetherOnline.GameTypesFixtures

  test "get_table!/1 returns the table with given id" do
    table = TablesFixtures.table_fixture()
    loaded_table = Tables.get_table!(table.id)

    assert equal?(table, loaded_table)
  end

  test "get_table!/1 raises an error when there is not a matching table" do
    assert_raise Ecto.NoResultsError, fn -> Tables.get_table!(UUID.generate()) end
  end

  test "create_table/2 creates spades tables" do
    game_type = game_type_fixture(%{slug: "spades"})
    {:ok, table} = Tables.create_table(game_type, %{})
    [created_table] = Administration.Tables.list_tables()

    assert table.id == created_table.id
    assert created_table.status == "game-pending"
    assert created_table.game_type_id == game_type.id
  end

  test "create_table/2 creates spyfall tables" do
    game_type = game_type_fixture(%{slug: "spyfall"})
    {:ok, table} = Tables.create_table(game_type, %{})
    [created_table] = Administration.Tables.list_tables()

    assert table.id == created_table.id
    assert created_table.status == "game-pending"
    assert created_table.game_type_id == game_type.id
  end

  describe "track_presence/2" do
    import GameTogetherOnline.Administration.TablesFixtures
    import GameTogetherOnline.Administration.PlayersFixtures

    test "tracks presence of a player" do
      table = table_fixture()
      player = player_fixture()
      Presence.subscribe()
      Tables.track_presence(table, player)

      assert_receive %{event: "presence_diff", payload: payload}
      %{joins: %{"all_table_presences" => joins}, leaves: %{}} = payload
      %{metas: [%{player_id: player_id, table_id: table_id}]} = joins

      assert player_id == player.id
      assert table_id == table.id
    end
  end

  describe "untrack_presence/2" do
    import GameTogetherOnline.Administration.TablesFixtures
    import GameTogetherOnline.Administration.PlayersFixtures

    test "untracks presence of a player" do
      table = table_fixture()
      player = player_fixture()

      Presence.subscribe()
      Presence.track(table, player)

      assert_receive %{event: "presence_diff", payload: _payload}

      Presence.untrack()

      assert_receive %{event: "presence_diff", payload: payload}
      %{leaves: %{"all_table_presences" => leaves}, joins: %{}} = payload
      %{metas: [%{player_id: player_id, table_id: table_id}]} = leaves

      assert player_id == player.id
      assert table_id == table.id
    end
  end

  test "subscribe/1 subscibes to a table id" do
    game_type = game_type_fixture()
    {:ok, table} = Tables.create_table(game_type, %{})
    Tables.subscribe(table.id)
    Updates.broadcast(table)
    assert_receive ^table
  end

  test "subscribe/0 subscibes to all table updates" do
    game_type = game_type_fixture()
    {:ok, table} = Tables.create_table(game_type, %{})
    Tables.subscribe(table.id)
    Updates.broadcast(table)
    assert_receive ^table
  end

  defp equal?(first_table, second_table) do
    first_table.id == second_table.id &&
      first_table.status == second_table.status &&
      first_table.game_type_id == second_table.game_type_id
  end
end
