defmodule GameTogetherOnlineWeb.PageLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.GameTypes

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:game_types, list_game_types())}
  end

  defp list_game_types() do
    GameTypes.list_game_types()
  end
end
