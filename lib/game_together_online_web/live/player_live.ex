defmodule GameTogetherOnlineWeb.PlayerLive do
  import Phoenix.Component

  alias GameTogetherOnline.Players

  def on_mount(:mount_current_player, _params, %{"player_token" => player_token}, socket) do
    player = Players.get_player_by_session_token(player_token)
    {:cont, assign(socket, :current_player, player)}
  end
end
