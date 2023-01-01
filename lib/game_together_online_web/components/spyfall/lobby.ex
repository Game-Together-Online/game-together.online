defmodule GameTogetherOnlineWeb.Components.Spyfall.Lobby do
  use GameTogetherOnlineWeb, :live_component

  alias GameTogetherOnlineWeb.Components.LobbyHeader

  def render(assigns) do
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

            <div class="mt-6">
              <button
                type="button"
                class="w-full rounded-md border border-transparent bg-indigo-600 py-3 px-4 text-base font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 focus:ring-offset-gray-50"
              >
                Join The Game
              </button>
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
end
