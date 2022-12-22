defmodule GameTogetherOnlineWeb.ChatMessageLive.FormComponent do
  use GameTogetherOnlineWeb, :live_component

  alias GameTogetherOnline.Administration.ChatMessages

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage chat_message records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="chat_message-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :player_id}} type="text" label="player id" />
        <.input field={{f, :chat_id}} type="text" label="chat id" />
        <.input field={{f, :content}} type="text" label="content" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Chat message</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{chat_message: chat_message} = assigns, socket) do
    changeset = ChatMessages.change_chat_message(chat_message)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"chat_message" => chat_message_params}, socket) do
    changeset =
      socket.assigns.chat_message
      |> ChatMessages.change_chat_message(chat_message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"chat_message" => chat_message_params}, socket) do
    save_chat_message(socket, socket.assigns.action, chat_message_params)
  end

  defp save_chat_message(socket, :edit, chat_message_params) do
    case ChatMessages.update_chat_message(socket.assigns.chat_message, chat_message_params) do
      {:ok, _chat_message} ->
        {:noreply,
         socket
         |> put_flash(:info, "Chat message updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_chat_message(socket, :new, chat_message_params) do
    case ChatMessages.create_chat_message(chat_message_params) do
      {:ok, _chat_message} ->
        {:noreply,
         socket
         |> put_flash(:info, "Chat message created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
