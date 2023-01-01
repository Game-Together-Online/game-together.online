defmodule GameTogetherOnlineWeb.Administration.SpyfallParticipantLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.SpyfallParticipants
  alias GameTogetherOnline.Administration.SpyfallParticipants.SpyfallParticipant

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :spyfall_participants, list_spyfall_participants())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Spyfall participant")
    |> assign(:spyfall_participant, SpyfallParticipants.get_spyfall_participant!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Spyfall participant")
    |> assign(:spyfall_participant, %SpyfallParticipant{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Spyfall participants")
    |> assign(:spyfall_participant, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    spyfall_participant = SpyfallParticipants.get_spyfall_participant!(id)
    {:ok, _} = SpyfallParticipants.delete_spyfall_participant(spyfall_participant)

    {:noreply, assign(socket, :spyfall_participants, list_spyfall_participants())}
  end

  defp list_spyfall_participants do
    SpyfallParticipants.list_spyfall_participants()
  end
end
