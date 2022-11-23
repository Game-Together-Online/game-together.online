defmodule GameTogetherOnlineWeb.TableLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  alias GameTogetherOnline.Administration.TablesFixtures
  alias Ecto.UUID

  describe "Lobby" do
    test "raises an error with an invalid table id", %{conn: conn} do
      assert_raise Ecto.Query.CastError, fn -> live(conn, ~p"/tables/table-id/lobby") end
    end

    test "raises an error with an table id that doesn't reference a table", %{conn: conn} do
      table_id = UUID.generate()
      assert_raise Ecto.NoResultsError, fn -> live(conn, ~p"/tables/#{table_id}/lobby") end
    end

    test "shows the lobby when the table exists", %{conn: conn} do
      table = TablesFixtures.table_fixture()
      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby")

      assert html =~ "Lobby"
      assert html =~ "Copy Invite Link"
    end
  end
end
