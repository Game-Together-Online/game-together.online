defmodule GameTogetherOnlineWeb.Administration.PlayerLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  import GameTogetherOnline.Administration.PlayersFixtures
  import GameTogetherOnline.AccountsFixtures

  @create_attrs %{nickname: "some nickname"}
  @update_attrs %{nickname: "some updated nickname"}
  @invalid_attrs %{nickname: nil}

  defp create_player(_) do
    player = player_fixture()
    %{player: player}
  end

  describe "Index" do
    setup [:create_player]

    test "shows an empty state when there is no user for the player", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/administration/players")
      assert html =~ "No user"
    end

    test "shows the user for the player when there is one", %{conn: conn} do
      user = user_fixture()
      player_fixture(%{user_id: user.id})

      {:ok, _index_live, html} = live(conn, ~p"/administration/players")
      assert html =~ user.email
    end

    test "lists all players", %{conn: conn, player: player} do
      {:ok, _index_live, html} = live(conn, ~p"/administration/players")

      assert html =~ "Listing Players"
      assert html =~ player.nickname
    end

    test "saves new player", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/players")

      assert index_live |> element("a", "New Player") |> render_click() =~
               "New Player"

      assert_patch(index_live, ~p"/administration/players/new")

      assert index_live
             |> form("#player-form", player: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#player-form", player: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/players")

      assert html =~ "Player created successfully"
      assert html =~ "some nickname"
    end

    test "updates player in listing", %{conn: conn, player: player} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/players")

      assert index_live |> element("#players-#{player.id} a", "Edit") |> render_click() =~
               "Edit Player"

      assert_patch(index_live, ~p"/administration/players/#{player}/edit")

      assert index_live
             |> form("#player-form", player: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#player-form", player: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/players")

      assert html =~ "Player updated successfully"
      assert html =~ "some updated nickname"
    end

    test "deletes player in listing", %{conn: conn, player: player} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/players")

      assert index_live |> element("#players-#{player.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#player-#{player.id}")
    end
  end

  describe "Show" do
    setup [:create_player]

    test "displays player", %{conn: conn, player: player} do
      {:ok, _show_live, html} = live(conn, ~p"/administration/players/#{player}")

      assert html =~ "Show Player"
      assert html =~ player.nickname
    end

    test "updates player within modal", %{conn: conn, player: player} do
      {:ok, show_live, _html} = live(conn, ~p"/administration/players/#{player}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Player"

      assert_patch(show_live, ~p"/administration/players/#{player}/show/edit")

      assert show_live
             |> form("#player-form", player: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#player-form", player: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/players/#{player}")

      assert html =~ "Player updated successfully"
      assert html =~ "some updated nickname"
    end

    test "shows an empty state when there is no user for the player", %{
      conn: conn,
      player: player
    } do
      user_fixture(%{email: "first-email@something.org"})
      {:ok, _show_live, html} = live(conn, ~p"/administration/players/#{player}")
      assert html =~ "Associate a user"
    end

    test "when there is no player for the user it initially lists players who have not been assigned to a user",
         %{conn: conn} do
      user = user_fixture(%{email: "first-email@something.org"})
      second_user = user_fixture(%{email: "second-email@something.org"})
      player = player_fixture(%{user: user, nickname: "Player 1"})
      player_fixture(%{user_id: user.id})

      {:ok, _show_live, html} = live(conn, ~p"/administration/players/#{player}")

      assert html =~ second_user.email
      refute html =~ user.email
    end

    test "when there is no player for the user it initially shows an empty state when there are no players which have not been assigned to a user",
         %{conn: conn} do
      user = user_fixture(%{email: "first-email@something.org"})
      player = player_fixture(%{user: user, nickname: "Player 1"})
      player_fixture(%{user_id: user.id})

      {:ok, _show_live, html} = live(conn, ~p"/administration/players/#{player}")

      refute html =~ user.email
      assert html =~ "OOPS! No users found."
    end

    test "when there is no player for the user it filters players by nickname", %{conn: conn} do
      player = player_fixture()

      user_fixture(%{email: "first-email@something.org"})
      user_fixture(%{email: "second-email@something.org"})
      user_fixture(%{email: "missing@something.org"})

      {:ok, _live, html} = live(conn, ~p"/administration/players/#{player}")

      assert html =~ "first-email"
      assert html =~ "second-email"
      assert html =~ "missing"
    end

    test "when there is no player for the user it shows an empty state when there are no players which match the filter",
         %{conn: conn} do
      player = player_fixture()
      user_fixture(%{email: "first-email@something.org"})
      user_fixture(%{email: "second-email@something.org"})
      user_fixture(%{email: "missing@something.org"})

      {:ok, live, _html} = live(conn, ~p"/administration/players/#{player}")

      html =
        live
        |> form("#user-email-form", user: %{email: "Z"})
        |> render_change()

      refute html =~ "first-email"
      refute html =~ "second-email"
      refute html =~ "missing"
      assert html =~ "No users without a player were found with an email that matches"
    end

    test "shows the user for the player when there is one", %{conn: conn} do
      user = user_fixture()
      player = player_fixture(%{user_id: user.id})

      {:ok, _live, html} = live(conn, ~p"/administration/players/#{player}")
      assert html =~ user.email
    end
  end
end
