defmodule GameTogetherOnlineWeb.Administration.PlayerLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.Players
  alias GameTogetherOnline.Administration.Players.Player

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Players.subscribe_to_updates()
    end

    {:ok, assign(socket, :players, list_players())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Player")
    |> assign(:player, Players.get_player!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Player")
    |> assign(:player, %Player{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Players")
    |> assign(:player, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    player = Players.get_player!(id)
    {:ok, _} = Players.delete_player(player)

    {:noreply, assign(socket, :players, list_players())}
  end

  @impl true
  def handle_info(player, socket) do
    %{players: players} = socket.assigns
    {:noreply, assign(socket, :players, replace_player(players, player))}
  end

  defp replace_player(players, player) do
    Enum.map(players, &replace_if_ids_match(&1, player))
  end

  defp replace_if_ids_match(%{id: id}, %{id: id} = player), do: player
  defp replace_if_ids_match(original_player, _player), do: original_player

  defp list_players do
    Players.list_players()
  end
end
