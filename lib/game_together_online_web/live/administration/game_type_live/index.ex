defmodule GameTogetherOnlineWeb.Administration.GameTypeLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.GameTypes
  alias GameTogetherOnline.Administration.GameTypes.GameType

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :game_types, list_game_types())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Game type")
    |> assign(:game_type, GameTypes.get_game_type!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Game type")
    |> assign(:game_type, %GameType{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Game types")
    |> assign(:game_type, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    game_type = GameTypes.get_game_type!(id)
    {:ok, _} = GameTypes.delete_game_type(game_type)

    {:noreply, assign(socket, :game_types, list_game_types())}
  end

  defp list_game_types do
    GameTypes.list_game_types()
  end
end
