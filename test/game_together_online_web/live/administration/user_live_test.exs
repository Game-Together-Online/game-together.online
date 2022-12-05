defmodule GameTogetherOnlineWeb.Administration.UserLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  import GameTogetherOnline.AccountsFixtures
  import GameTogetherOnline.Administration.PlayersFixtures

  alias GameTogetherOnline.Administration.Players

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  describe "Index" do
    setup [:create_user]

    test "links back to the administration page", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/users")

      assert index_live
             |> element("a", "Back to administration")
             |> render_click() ==
               {:error, {:live_redirect, %{kind: :push, to: ~p"/administration"}}}
    end

    test "lists all users", %{conn: conn, user: user} do
      {:ok, _index_live, html} = live(conn, ~p"/administration/users")

      assert html =~ "Listing Users"
      assert html =~ user.email
    end

    test "shows an empty state when there is no player for the user", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/administration/users")
      assert html =~ "No player"
    end
  end

  describe "Show" do
    setup [:create_user]

    test "displays user", %{conn: conn, user: user} do
      {:ok, _show_live, html} = live(conn, ~p"/administration/users/#{user}")

      assert html =~ "User #{user.id}"
      assert html =~ user.email
    end

    test "shows an empty state when there is no player for the user", %{conn: conn, user: user} do
      {:ok, _show_live, html} = live(conn, ~p"/administration/users/#{user}")

      assert html =~ "User #{user.id}"
      assert html =~ user.email
      assert html =~ "Associate a player"
    end

    test "it initially lists players who have not been assigned to a user", %{conn: conn} do
      user = user_fixture()

      player_fixture(%{nickname: "first-player"})
      player_fixture(%{nickname: "second-player", user_id: user.id})

      {:ok, _show_live, html} = live(conn, ~p"/administration/users/#{user}")

      assert html =~ "first-player"
      refute html =~ "second-player"
    end

    test "it initially shows an empty state when there are no players which have not been assigned to a user",
         %{conn: conn} do
      user = user_fixture()
      conn = get(conn, ~p"/")

      [player] = Players.list_players()
      {:ok, _player} = Players.update_player(player, %{user_id: user.id})

      assert conn
             |> get(~p"/administration/users/#{user}")
             |> html_response(200) =~ "OOPS! No players found."
    end

    test "it filters players by nickname", %{conn: conn} do
      user = user_fixture()
      player_fixture(%{nickname: "playernick"})

      {:ok, live, _html} = live(conn, ~p"/administration/users/#{user}")

      html =
        live
        |> form("#player-nickname-form", player: %{nickname: "player"})
        |> render_change()

      refute html =~ "Anonymous"
      assert html =~ "playernick"
    end

    test "it shows an empty state when there are no players which match the filter", %{conn: conn} do
      user = user_fixture()

      {:ok, live, _html} = live(conn, ~p"/administration/users/#{user}")

      html =
        live
        |> form("#player-nickname-form", player: %{nickname: "ZZZ"})
        |> render_change()

      refute html =~ "Anonymous"
      assert html =~ "No players without a user were found with a nickname that matches"
    end
  end
end
