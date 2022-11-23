defmodule GameTogetherOnlineWeb.TableLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnlineWeb.TableLive.IndexHTML
  alias GameTogetherOnline.Tables

  def handle_params(%{"id" => id}, url, socket) do
    {:noreply,
     socket
     |> assign(table: Tables.get_table!(id))
     |> assign(invite_url: url)}
  end

  def render(%{live_action: :lobby} = assigns), do: IndexHTML.lobby(assigns)
end
