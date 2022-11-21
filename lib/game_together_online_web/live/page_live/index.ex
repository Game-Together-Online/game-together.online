defmodule GameTogetherOnlineWeb.PageLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.GameTypes
  alias GameTogetherOnline.Tables

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:game_types, list_game_types())}
  end

  @impl true
  def handle_event("create_table", %{"game_type_slug" => game_type_slug}, socket) do
    game_type = GameTypes.get_game_type_by_slug!(game_type_slug)
    {:ok, table} = Tables.create_table(game_type, %{})
    {:noreply, push_navigate(socket, to: ~p"/tables/#{table.id}/lobby")}
  end

  defp list_game_types() do
    GameTypes.list_game_types()
  end
end
