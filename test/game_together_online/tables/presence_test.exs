defmodule GameTogetherOnline.Tables.PresenceTest do
  use GameTogetherOnline.DataCase

  import GameTogetherOnline.Administration.TablesFixtures
  import GameTogetherOnline.Administration.PlayersFixtures

  alias GameTogetherOnline.Tables.Presence

  setup :generate_table_and_player

  test "track/2 tracks presence", %{table: table, player: player} do
    Presence.subscribe()
    Presence.track(table, player)

    assert_receive %{event: "presence_diff", payload: payload}
    %{joins: %{"all_table_presences" => joins}, leaves: %{}} = payload
    %{metas: [%{player_id: player_id, table_id: table_id}]} = joins

    assert player_id == player.id
    assert table_id == table.id
  end

  test "untrack/2 untracks presence", %{table: table, player: player} do
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

  def generate_table_and_player(_) do
    table = table_fixture()
    player = player_fixture()
    {:ok, table: table, player: player}
  end
end
