defmodule GameTogetherOnlineWeb.TableLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Lobby" do
    test "shows the lobby", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/tables/table-id/lobby")

      assert html =~ "Lobby"
    end
  end
end
