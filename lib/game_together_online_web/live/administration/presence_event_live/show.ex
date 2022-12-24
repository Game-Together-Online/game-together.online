defmodule GameTogetherOnlineWeb.Administration.PresenceEventLive.Show do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.PresenceEvents

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:presence_event, PresenceEvents.get_presence_event!(id))}
  end

  defp page_title(:show), do: "Show Presence event"
  defp page_title(:edit), do: "Edit Presence event"
end
