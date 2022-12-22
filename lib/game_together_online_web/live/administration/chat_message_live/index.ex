defmodule GameTogetherOnlineWeb.Administration.ChatMessageLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.ChatMessages
  alias GameTogetherOnline.Administration.ChatMessages.ChatMessage

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :chat_messages, list_chat_messages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Chat message")
    |> assign(:chat_message, ChatMessages.get_chat_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Chat message")
    |> assign(:chat_message, %ChatMessage{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Chat messages")
    |> assign(:chat_message, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    chat_message = ChatMessages.get_chat_message!(id)
    {:ok, _} = ChatMessages.delete_chat_message(chat_message)

    {:noreply, assign(socket, :chat_messages, list_chat_messages())}
  end

  defp list_chat_messages do
    ChatMessages.list_chat_messages()
  end
end
