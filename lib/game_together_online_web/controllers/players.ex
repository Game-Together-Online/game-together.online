defmodule GameTogetherOnlineWeb.Player do
  @moduledoc """
  A module for managing a connection's player state
  """
  import Plug.Conn

  alias GameTogetherOnline.Players
  alias GameTogetherOnline.Players.Player

  def fetch_current_player(conn, _opts) do
    player_token = get_session(conn, :player_token)
    player = player_token && Players.get_player_by_session_token(player_token)
    assign(conn, :current_player, player)
  end

  def ensure_current_player_exists(conn, _opts) do
    if Map.get(conn.assigns, :current_player) do
      conn
    else
      generate_new_player(conn)
    end
  end

  defp generate_new_player(conn) do
    nickname = Player.generate_default_nickname()
    {:ok, player} = Players.create_player(%{nickname: nickname})
    player_token = Players.generate_player_session_token(player)

    conn
    |> put_session(:player_token, player_token)
    |> assign(:current_player, player)
  end
end
