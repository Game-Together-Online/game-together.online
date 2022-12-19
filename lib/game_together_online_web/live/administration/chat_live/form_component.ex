defmodule GameTogetherOnlineWeb.Administration.ChatLive.FormComponent do
  use GameTogetherOnlineWeb, :live_component

  alias GameTogetherOnline.Administration.Chats

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage chat records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="chat-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :table_id}} type="text" label="table" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Chat</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{chat: chat} = assigns, socket) do
    changeset = Chats.change_chat(chat)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"chat" => chat_params}, socket) do
    changeset =
      socket.assigns.chat
      |> Chats.change_chat(chat_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"chat" => chat_params}, socket) do
    save_chat(socket, socket.assigns.action, chat_params)
  end

  defp save_chat(socket, :edit, chat_params) do
    case Chats.update_chat(socket.assigns.chat, chat_params) do
      {:ok, _chat} ->
        {:noreply,
         socket
         |> put_flash(:info, "Chat updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_chat(socket, :new, chat_params) do
    case Chats.create_chat(chat_params) do
      {:ok, _chat} ->
        {:noreply,
         socket
         |> put_flash(:info, "Chat created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
