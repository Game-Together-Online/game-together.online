defmodule GameTogetherOnlineWeb.Administration.GameTypeLive.Show do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.GameTypes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:game_type, GameTypes.get_game_type!(id))}
  end

  defp page_title(:show), do: "Show Game type"
  defp page_title(:edit), do: "Edit Game type"
end
