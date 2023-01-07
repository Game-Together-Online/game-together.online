defmodule GameTogetherOnlineWeb.Components.Spyfall.Lobby do
  use GameTogetherOnlineWeb, :live_component

  alias GameTogetherOnlineWeb.Components.LobbyHeader
  alias GameTogetherOnline.Tables
  alias GameTogetherOnline.SpyfallParticipants

  def handle_event("toggle_ready_to_play", _params, socket) do
    %{table: table} = socket.assigns

    {:ok, _spyfall_participant} =
      socket.assigns
      |> participant_for_current_player()
      |> SpyfallParticipants.toggle_readiness()

    Tables.broadcast(table.id)

    {:noreply, socket}
  end

  def handle_event("add_user_to_game", _params, socket) do
    %{table: table, current_player: current_player} = socket.assigns
    %{spyfall_game: spyfall_game} = table

    SpyfallParticipants.create_spyfall_participant(%{
      ready_to_start: true,
      spyfall_game_id: spyfall_game.id,
      player_id: current_player.id
    })

    Tables.broadcast(table.id)
    {:noreply, socket}
  end

  def handle_event("remove_user_from_game", _params, socket) do
    %{table: table, current_player: current_player} = socket.assigns
    %{spyfall_game: spyfall_game} = table

    SpyfallParticipants.delete_spyfall_participant_by_game_and_player(
      spyfall_game.id,
      current_player.id
    )

    Tables.broadcast(table.id)
    {:noreply, socket}
  end

  def render(assigns) do
    assigns =
      assigns
      |> set_current_player_has_joined()
      |> set_current_player_ready_to_play()

    ~H"""
    <div>
      <.live_component
        id={"lobby-header-for-table-#{@table.id}"}
        module={LobbyHeader}
        current_player={@current_player}
        current_tab={@current_tab}
        table={@table}
      >
        <:actions>
          <.link
            patch={~p"/tables/#{@table.id}/lobby?tab=#{@current_tab}&edit_nickname=true"}
            class="inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
          >
            Change Your Nickname
          </.link>
        </:actions>
      </.live_component>
      <div class="flex mt-8 flex-col md:flex-row space-y-4">
        <div class="overflow-hidden rounded-lg bg-gray-50 w-full md:w-96">
          <div class="px-4 py-5 sm:p-6">
            <h2 id="summary-heading" class="text-lg font-medium text-gray-900">Game Settings</h2>

            <dl class="mt-6 space-y-4">
              <div class="flex items-center justify-between">
                <dt class="text-sm text-gray-600">Round Time Limit</dt>
                <dd class="text-sm font-medium text-gray-900">8 Minutes</dd>
              </div>
            </dl>

            <div class="mt-6 space-y-2">
              <%= if @current_player_has_joined do %>
                <div class="flex flex-row justify-end">
                  <div class="flex h-5 items-center">
                    <input
                      id="comments"
                      phx-click="toggle_ready_to_play"
                      phx-target={@myself}
                      aria-describedby="comments-description"
                      name="comments"
                      type="checkbox"
                      checked={@current_player_ready_to_play}
                      class="h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
                    />
                  </div>
                  <div class="ml-3 text-sm">
                    <label for="comments" class="font-medium text-gray-700">Ready To Start</label>
                  </div>
                </div>
                <button
                  phx-click="remove_user_from_game"
                  phx-target={@myself}
                  type="button"
                  class="w-full items-center rounded-md border border-transparent bg-indigo-100 py-3 text-base font-medium text-indigo-700 hover:bg-indigo-200 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                >
                  Leave The Game
                </button>
              <% else %>
                <button
                  type="button"
                  phx-click="add_user_to_game"
                  phx-target={@myself}
                  class="w-full rounded-md border border-transparent bg-indigo-600 py-3 text-base font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 focus:ring-offset-gray-50"
                >
                  Join The Game
                </button>
              <% end %>
            </div>
          </div>
        </div>

        <div class="hidden md:block">
          SPYFALL! <%= @table.id %>
        </div>
      </div>
    </div>
    """
  end

  defp set_current_player_has_joined(assigns) do
    assign(
      assigns,
      :current_player_has_joined,
      participant_for_current_player(assigns) != nil
    )
  end

  defp set_current_player_ready_to_play(assigns) do
    participant = participant_for_current_player(assigns)

    assign(
      assigns,
      :current_player_ready_to_play,
      participant != nil && participant.ready_to_start
    )
  end

  defp participant_for_current_player(assigns) do
    %{
      current_player: %{id: current_player_id},
      table: %{spyfall_game: %{spyfall_participants: spyfall_participants}}
    } = assigns

    Enum.find(spyfall_participants, &(&1.player_id == current_player_id))
  end
end
