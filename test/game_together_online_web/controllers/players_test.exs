defmodule GameTogetherOnlineWeb.PlayerTest do
  use GameTogetherOnlineWeb.ConnCase, async: true

  alias GameTogetherOnlineWeb.Player

  describe "fetch_current_player/2" do
    test "stores nil in the connection when there is no player token", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{})
        |> Player.fetch_current_player(conn)

      refute Map.get(conn.assigns, :current_player)
    end

    test "stores nil in the connection when there is no player matching the player token", %{
      conn: conn
    } do
      conn
      |> init_test_session(%{})
      |> Player.fetch_current_player(nil)

      refute Map.get(conn.assigns, :current_player)
    end

    test "stores the player in the connection when there is no player matching the player token",
         %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{})
        |> Player.ensure_current_player_exists(nil)
        |> Player.fetch_current_player(nil)

      assert Map.get(conn.assigns, :current_player)
    end
  end

  describe "ensure_player_exists/2" do
    test "adds a player token to the session when there is no player", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{})
        |> Player.ensure_current_player_exists(nil)

      assert get_session(conn, :player_token)
    end

    test "adds a player to the connection when there is no player", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{})
        |> Player.ensure_current_player_exists(nil)

      assert Map.get(conn.assigns, :current_player)
    end

    test "does not change the connection when there is a player present", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{})
        |> Player.ensure_current_player_exists(nil)

      assert conn == Player.ensure_current_player_exists(conn, nil)
    end
  end
end
