defmodule GameTogetherOnlineWeb.TableLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnlineWeb.TableLive.IndexHTML
  alias GameTogetherOnline.Tables

  def handle_params(%{"id" => id}, _url, socket) do
    {:noreply, assign(socket, table: Tables.get_table!(id))}
  end

  def render(%{live_action: :lobby} = assigns), do: IndexHTML.lobby(assigns)
end
