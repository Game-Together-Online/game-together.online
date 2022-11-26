defmodule GameTogetherOnlineWeb.TableLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnlineWeb.TableLive.IndexHTML
  alias GameTogetherOnline.Tables

  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:current_player, socket.assigns.current_player)
     |> assign(table: Tables.get_table!(id))}
  end

  def handle_params(params, url, socket) do
    {:noreply,
     socket
     |> assign(invite_url: url)
     |> assign(show_edit_nickname_modal: show_edit_nickname?(params))}
  end

  def render(%{live_action: :lobby} = assigns), do: IndexHTML.lobby(assigns)

  defp show_edit_nickname?(params), do: Map.has_key?(params, "edit_nickname")
end
