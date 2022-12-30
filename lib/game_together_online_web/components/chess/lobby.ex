defmodule GameTogetherOnlineWeb.Components.Chess.Lobby do
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
      CHESS table <%= @table.id %>
    </div>
    """
  end
end
