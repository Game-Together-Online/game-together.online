defmodule GameTogetherOnline.Tables.PresenceServerTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Tables.PresenceServer
  alias GameTogetherOnline.Tables.TablePresence
  alias GameTogetherOnline.Tables.Updates
  alias GameTogetherOnline.Repo

  import GameTogetherOnline.Administration.PlayersFixtures
  import GameTogetherOnline.Administration.TablesFixtures

  test "presence server inserts table presences" do
    Updates.subscribe()
    %{id: player_id} = player_fixture()
    %{id: table_id} = table_fixture()

    joins = %{"all_table_presences" => %{metas: [%{player_id: player_id, table_id: table_id}]}}
    leaves = %{"all_table_presences" => %{metas: []}}
    payload = %{joins: joins, leaves: leaves}
    PresenceServer.handle_info(%{payload: payload}, %{})

    assert [%{player_id: ^player_id, table_id: ^table_id}] = Repo.all(TablePresence)

    assert_receive table
    assert [%{id: ^player_id}] = table.players_present
  end

  test "presence server deletes table presences" do
    Updates.subscribe()
    %{id: player_id} = player_fixture()
    %{id: table_id} = table_fixture()

    change = %{"all_table_presences" => %{metas: [%{player_id: player_id, table_id: table_id}]}}
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
end
