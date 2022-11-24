defmodule GameTogetherOnlineWeb.Live.Components.Spyfall.LobbyTest do
  use GameTogetherOnline.DataCase
  import Phoenix.LiveViewTest

  import GameTogetherOnline.Administration.TablesFixtures
  alias GameTogetherOnlineWeb.Components.Spyfall.Lobby

  test "shows the table id" do
    table = table_fixture()
    assert render_component(Lobby, table: table) =~ table.id
  end
end
