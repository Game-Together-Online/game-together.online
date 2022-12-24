defmodule GameTogetherOnlineWeb.Administration.PresenceEventLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.PresenceEvents
  alias GameTogetherOnline.Administration.PresenceEvents.PresenceEvent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :presence_events, list_presence_events())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Presence event")
    |> assign(:presence_event, PresenceEvents.get_presence_event!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Presence event")
    |> assign(:presence_event, %PresenceEvent{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Presence events")
    |> assign(:presence_event, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    presence_event = PresenceEvents.get_presence_event!(id)
    {:ok, _} = PresenceEvents.delete_presence_event(presence_event)

    {:noreply, assign(socket, :presence_events, list_presence_events())}
  end

  defp list_presence_events do
    PresenceEvents.list_presence_events()
  end
end
