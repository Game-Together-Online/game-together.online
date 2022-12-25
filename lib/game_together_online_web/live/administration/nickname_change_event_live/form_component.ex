defmodule GameTogetherOnlineWeb.Administration.NicknameChangeEventLive.FormComponent do
  use GameTogetherOnlineWeb, :live_component

  alias GameTogetherOnline.Administration.NicknameChangeEvents

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage nickname_change_event records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="nickname_change_event-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :player_id}} type="text" label="player_id" />
        <.input field={{f, :original_nickname}} type="text" label="original_nickname" />
        <.input field={{f, :new_nickname}} type="text" label="new_nickname" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Nickname change event</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{nickname_change_event: nickname_change_event} = assigns, socket) do
    changeset = NicknameChangeEvents.change_nickname_change_event(nickname_change_event)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"nickname_change_event" => nickname_change_event_params}, socket) do
    changeset =
      socket.assigns.nickname_change_event
      |> NicknameChangeEvents.change_nickname_change_event(nickname_change_event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"nickname_change_event" => nickname_change_event_params}, socket) do
    save_nickname_change_event(socket, socket.assigns.action, nickname_change_event_params)
  end

  defp save_nickname_change_event(socket, :edit, nickname_change_event_params) do
    case NicknameChangeEvents.update_nickname_change_event(
           socket.assigns.nickname_change_event,
           nickname_change_event_params
         ) do
      {:ok, _nickname_change_event} ->
        {:noreply,
         socket
         |> put_flash(:info, "Nickname change event updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_nickname_change_event(socket, :new, nickname_change_event_params) do
    case NicknameChangeEvents.create_nickname_change_event(nickname_change_event_params) do
      {:ok, _nickname_change_event} ->
        {:noreply,
         socket
         |> put_flash(:info, "Nickname change event created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
