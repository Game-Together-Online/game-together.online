defmodule GameTogetherOnlineWeb.Administration.Spyfall.LocationLive.Show do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.Spyfall

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:location, Spyfall.get_location!(id))}
  end

  defp page_title(:show), do: "Show Spyfall Location"
  defp page_title(:edit), do: "Edit Spyfall Location"
end
