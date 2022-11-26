defmodule GameTogetherOnlineWeb.Administration.UserLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  import GameTogetherOnline.AccountsFixtures

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
  end

  describe "Show" do
    setup [:create_user]

    test "displays user", %{conn: conn, user: user} do
      {:ok, _show_live, html} = live(conn, ~p"/administration/users/#{user}")

      assert html =~ "User #{user.id}"
      assert html =~ user.email
    end
  end
end
