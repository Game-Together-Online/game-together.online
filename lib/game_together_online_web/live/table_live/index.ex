defmodule GameTogetherOnlineWeb.TableLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnlineWeb.TableLive.IndexHTML
  alias GameTogetherOnline.Tables

  @default_tab "chat"

  def mount(%{"id" => id}, _session, socket) do
    table = Tables.get_table!(id)

    if connected?(socket) do
      Tables.subscribe(id)
      Tables.track_presence(table, socket.assigns.current_player)
    end

    {:ok,
     socket
     |> assign(:current_player, socket.assigns.current_player)
     |> assign(table: table)}
  end

  def handle_params(params, url, socket) do
    current_tab = Map.get(params, "tab", @default_tab)

    {:noreply,
     socket
     |> assign(invite_url: url)
     |> assign(current_tab: current_tab)
     |> assign(show_edit_nickname_modal: show_edit_nickname?(params))}
  end

  def handle_info(table, socket) do
    {:noreply, assign(socket, table: table)}
  end

  def handle_event("select_tab", %{"tab" => tab}, socket) do
    {:noreply, push_patch(socket, to: ~p"/tables/#{socket.assigns.table.id}/lobby?tab=#{tab}")}
  end

  def render(%{live_action: :lobby} = assigns), do: IndexHTML.lobby(assigns)

  defp show_edit_nickname?(params), do: Map.has_key?(params, "edit_nickname")
end
