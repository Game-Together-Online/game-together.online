defmodule GameTogetherOnlineWeb.Administration.NicknameChangeEventLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.NicknameChangeEvents
  alias GameTogetherOnline.Administration.NicknameChangeEvents.NicknameChangeEvent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :nickname_change_events, list_nickname_change_events())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Nickname change event")
    |> assign(:nickname_change_event, NicknameChangeEvents.get_nickname_change_event!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Nickname change event")
    |> assign(:nickname_change_event, %NicknameChangeEvent{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Nickname change events")
    |> assign(:nickname_change_event, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    nickname_change_event = NicknameChangeEvents.get_nickname_change_event!(id)
    {:ok, _} = NicknameChangeEvents.delete_nickname_change_event(nickname_change_event)

    {:noreply, assign(socket, :nickname_change_events, list_nickname_change_events())}
  end

  defp list_nickname_change_events do
    NicknameChangeEvents.list_nickname_change_events()
  end
end
