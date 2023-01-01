defmodule GameTogetherOnlineWeb.Administration.SpyfallParticipantLive.FormComponent do
  use GameTogetherOnlineWeb, :live_component

  alias GameTogetherOnline.Administration.SpyfallParticipants

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage spyfall_participant records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="spyfall_participant-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :spyfall_game_id}} type="text" label="spyfall game id" />
        <.input field={{f, :player_id}} type="text" label="player id" />
        <.input field={{f, :ready_to_start}} type="checkbox" label="ready_to_start" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Spyfall participant</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{spyfall_participant: spyfall_participant} = assigns, socket) do
    changeset = SpyfallParticipants.change_spyfall_participant(spyfall_participant)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"spyfall_participant" => spyfall_participant_params}, socket) do
    changeset =
      socket.assigns.spyfall_participant
      |> SpyfallParticipants.change_spyfall_participant(spyfall_participant_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"spyfall_participant" => spyfall_participant_params}, socket) do
    save_spyfall_participant(socket, socket.assigns.action, spyfall_participant_params)
  end

  defp save_spyfall_participant(socket, :edit, spyfall_participant_params) do
    case SpyfallParticipants.update_spyfall_participant(
           socket.assigns.spyfall_participant,
           spyfall_participant_params
         ) do
      {:ok, _spyfall_participant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Spyfall participant updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_spyfall_participant(socket, :new, spyfall_participant_params) do
    case SpyfallParticipants.create_spyfall_participant(spyfall_participant_params) do
      {:ok, _spyfall_participant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Spyfall participant created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
