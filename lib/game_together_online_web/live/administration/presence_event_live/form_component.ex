defmodule GameTogetherOnlineWeb.Administration.PresenceEventLive.FormComponent do
  use GameTogetherOnlineWeb, :live_component

  alias GameTogetherOnline.Administration.PresenceEvents

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage presence_event records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="presence_event-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :player_id}} type="text" label="player id" />
        <.input field={{f, :chat_id}} type="text" label="chat id" />
        <.input field={{f, :type}} type="text" label="type" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Presence event</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{presence_event: presence_event} = assigns, socket) do
    changeset = PresenceEvents.change_presence_event(presence_event)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"presence_event" => presence_event_params}, socket) do
    changeset =
      socket.assigns.presence_event
      |> PresenceEvents.change_presence_event(presence_event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"presence_event" => presence_event_params}, socket) do
    save_presence_event(socket, socket.assigns.action, presence_event_params)
  end

  defp save_presence_event(socket, :edit, presence_event_params) do
    case PresenceEvents.update_presence_event(
           socket.assigns.presence_event,
           presence_event_params
         ) do
      {:ok, _presence_event} ->
        {:noreply,
         socket
         |> put_flash(:info, "Presence event updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_presence_event(socket, :new, presence_event_params) do
    case PresenceEvents.create_presence_event(presence_event_params) do
      {:ok, _presence_event} ->
        {:noreply,
         socket
         |> put_flash(:info, "Presence event created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
