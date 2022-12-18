defmodule GameTogetherOnlineWeb.TableLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  alias GameTogetherOnline.Tables
  alias GameTogetherOnline.Tables.PresenceServer
  alias GameTogetherOnline.Administration.TablesFixtures
  alias GameTogetherOnline.Administration.PlayersFixtures
  alias GameTogetherOnline.Administration.GameTypesFixtures
  alias Ecto.UUID

  describe "Lobby" do
    test "shows the edit nickname modal when the edit_nickname query param is present", %{
      conn: conn
    } do
      table = TablesFixtures.table_fixture()
      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby?edit_nickname")
      assert html =~ "change-nickname-modal"
    end

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

      assert html =~ "Welcome to the game,"
      assert html =~ "Copy Invite Link"
      refute html =~ "change-nickname-modal"
    end

    test "shows the spades lobby for spades tables", %{conn: conn} do
      table = TablesFixtures.table_fixture()
      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby")

      assert html =~ "SPADES"
    end

    test "shows the spyfall lobby for spyfall tables", %{conn: conn} do
      spyfall_game_type = GameTypesFixtures.game_type_fixture(%{slug: "spyfall"})
      table = TablesFixtures.table_fixture(%{game_type_id: spyfall_game_type.id})
      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby")

      assert html =~ "SPYFALL"
    end

    test "allows players to update their nickname", %{conn: conn} do
      table = TablesFixtures.table_fixture()
      {:ok, index_live, _html} = live(conn, ~p"/tables/#{table.id}/lobby")

      assert index_live |> element("a", "Change Your Nickname") |> render_click() =~
               "Save"

      assert_patch(index_live, ~p"/tables/#{table.id}/lobby?tab=chat&edit_nickname=true")

      assert index_live
             |> form("#change-nickname-form", player: %{nickname: ""})
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#change-nickname-form", player: %{nickname: "New Nickname"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/tables/#{table.id}/lobby?tab=chat")

      assert html =~ "Nickname updated successfully"
    end

    test "shows the chat tab by default", %{conn: conn} do
      table = TablesFixtures.table_fixture()
      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby")

      assert html =~ "Current tab: chat"
    end

    test "shows the chat tab when it has been selected", %{conn: conn} do
      table = TablesFixtures.table_fixture()
      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby?tab=chat")

      assert html =~ "Current tab: chat"
    end

    test "shows the players present tab when it has been selected", %{conn: conn} do
      table = TablesFixtures.table_fixture()
      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby?tab=players_present")

      refute html =~ "Current tab: chat"
    end

    test "shows an empty state for the players present tab", %{conn: conn} do
      table = TablesFixtures.table_fixture()
      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby?tab=players_present")

      assert html =~ "There&#39;s nobody else here"
    end

    test "shows the players present", %{conn: conn} do
      start_supervised!(PresenceServer)
      table = TablesFixtures.table_fixture()
      other_player = PlayersFixtures.player_fixture()
      Tables.track_presence(table, other_player)

      {:ok, index_live, _html} = live(conn, ~p"/tables/#{table.id}/lobby?tab=players_present")

      assert render(index_live) =~ other_player.nickname
    end

    test "maintains the players present tab when the player updates their nickname", %{conn: conn} do
      table = TablesFixtures.table_fixture()
      {:ok, index_live, _html} = live(conn, ~p"/tables/#{table.id}/lobby?tab=players_present")

      assert index_live |> element("a", "Change Your Nickname") |> render_click() =~
               "Save"

      {:ok, _, html} =
        index_live
        |> form("#change-nickname-form", player: %{nickname: "New Nickname"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/tables/#{table.id}/lobby?tab=players_present")

      refute html =~ "Current tab: chat"
    end

    test "switches to the players present tab", %{conn: conn} do
      table = TablesFixtures.table_fixture()
      conn = get(conn, ~p"/tables/#{table.id}/lobby")
      {:ok, index_live, _html} = live(conn, ~p"/tables/#{table.id}/lobby")

      assert index_live
             |> element("button", "Players Present")
             |> render_click() =~ conn.assigns.current_player.nickname
    end
  end
end
