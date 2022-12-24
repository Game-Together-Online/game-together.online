defmodule GameTogetherOnline.Tables.PresenceServerTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Tables.PresenceServer
  alias GameTogetherOnline.Tables.TablePresence
  alias GameTogetherOnline.Tables.Updates
  alias GameTogetherOnline.Tables
  alias GameTogetherOnline.Repo

  import GameTogetherOnline.Administration.PlayersFixtures
  alias GameTogetherOnline.Administration.PresenceEvents
  alias GameTogetherOnline.Administration.GameTypesFixtures

  setup :create_table

  test "presence server inserts presence join events", %{table: table} do
    %{id: player_id} = player_fixture()

    joins = %{"all_table_presences" => %{metas: [%{player_id: player_id, table_id: table.id}]}}
    leaves = %{"all_table_presences" => %{metas: []}}
    payload = %{joins: joins, leaves: leaves}
    PresenceServer.handle_info(%{payload: payload}, %{})

    [presence_event] = PresenceEvents.list_presence_events()

    assert presence_event.player_id == player_id
    assert presence_event.type == "join"
  end

  test "presence server inserts presence leave events", %{table: table} do
    %{id: player_id} = player_fixture()

    leaves = %{"all_table_presences" => %{metas: [%{player_id: player_id, table_id: table.id}]}}
    joins = %{"all_table_presences" => %{metas: []}}
    payload = %{joins: joins, leaves: leaves}
    PresenceServer.handle_info(%{payload: payload}, %{})

    [presence_event] = PresenceEvents.list_presence_events()

    assert presence_event.player_id == player_id
    assert presence_event.type == "leave"
  end

  test "presence server inserts table presences", %{table: table} do
    Updates.subscribe()
    %{id: player_id} = player_fixture()

    joins = %{"all_table_presences" => %{metas: [%{player_id: player_id, table_id: table.id}]}}
    leaves = %{"all_table_presences" => %{metas: []}}
    payload = %{joins: joins, leaves: leaves}
    PresenceServer.handle_info(%{payload: payload}, %{})

    table_id = table.id
    assert [%{player_id: ^player_id, table_id: ^table_id}] = Repo.all(TablePresence)

    assert_receive table
    assert [%{id: ^player_id}] = table.players_present
  end

  test "presence server deletes table presences", %{table: table} do
    Updates.subscribe()
    %{id: player_id} = player_fixture()

    change = %{"all_table_presences" => %{metas: [%{player_id: player_id, table_id: table.id}]}}
    no_change = %{"all_table_presences" => %{metas: []}}

    payload = %{joins: change, leaves: no_change}
    PresenceServer.handle_info(%{payload: payload}, %{})

    assert_receive table
    assert [%{id: ^player_id}] = table.players_present

    payload = %{joins: no_change, leaves: change}
    PresenceServer.handle_info(%{payload: payload}, %{})

    assert TablePresence
           |> Repo.all()
           |> length() == 0

    assert_receive table
    assert [] = table.players_present
  end

  def create_table(_) do
    game_type = GameTypesFixtures.game_type_fixture()
    {:ok, table} = Tables.create_table(game_type, %{})
    %{table: table}
  end
end
