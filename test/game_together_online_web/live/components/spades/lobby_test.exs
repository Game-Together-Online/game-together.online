defmodule GameTogetherOnlineWeb.Live.Components.Spades.LobbyTest do
  use GameTogetherOnline.DataCase

  import Phoenix.LiveViewTest

  import GameTogetherOnline.Administration.TablesFixtures
  import GameTogetherOnline.Administration.PlayersFixtures
  alias GameTogetherOnlineWeb.Components.Spades.Lobby

  test "shows the table id" do
    player = player_fixture()
    table = table_fixture()

    assert render_component(Lobby, table: table, current_player: player, current_tab: "chat") =~
             table.id
  end
end
