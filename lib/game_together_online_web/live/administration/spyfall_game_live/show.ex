defmodule GameTogetherOnlineWeb.Administration.SpyfallGameLive.Show do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.SpyfallGames

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:spyfall_game, SpyfallGames.get_spyfall_game!(id))}
  end

  defp page_title(:show), do: "Show Spyfall game"
  defp page_title(:edit), do: "Edit Spyfall game"
end
