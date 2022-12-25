defmodule GameTogetherOnlineWeb.Administration.NicknameChangeEventLive.Show do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.NicknameChangeEvents

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:nickname_change_event, NicknameChangeEvents.get_nickname_change_event!(id))}
  end

  defp page_title(:show), do: "Show Nickname change event"
  defp page_title(:edit), do: "Edit Nickname change event"
end
