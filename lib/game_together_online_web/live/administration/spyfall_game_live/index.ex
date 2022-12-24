defmodule GameTogetherOnlineWeb.Administration.SpyfallGameLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.SpyfallGames
  alias GameTogetherOnline.Administration.SpyfallGames.SpyfallGame

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :spyfall_games, list_spyfall_games())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Spyfall game")
    |> assign(:spyfall_game, SpyfallGames.get_spyfall_game!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Spyfall game")
    |> assign(:spyfall_game, %SpyfallGame{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Spyfall games")
    |> assign(:spyfall_game, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    spyfall_game = SpyfallGames.get_spyfall_game!(id)
    {:ok, _} = SpyfallGames.delete_spyfall_game(spyfall_game)

    {:noreply, assign(socket, :spyfall_games, list_spyfall_games())}
  end

  defp list_spyfall_games do
    SpyfallGames.list_spyfall_games()
  end
end
