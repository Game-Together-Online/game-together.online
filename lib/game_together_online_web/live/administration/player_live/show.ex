defmodule GameTogetherOnlineWeb.Administration.PlayerLive.Show do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.Players

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    if connected?(socket) do
      Players.subscribe_to_updates(id)

      if current_player = Map.get(socket.assigns, :player, nil) != nil do
        Players.unsubscribe_from_updates(current_player)
      end
    end

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:player, Players.get_player!(id))}
  end

  @impl true
  def handle_info(player, socket) do
    {:noreply, assign(socket, :player, player)}
  end

  defp page_title(:show), do: "Show Player"
  defp page_title(:edit), do: "Edit Player"
end
