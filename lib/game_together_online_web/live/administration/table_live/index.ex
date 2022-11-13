defmodule GameTogetherOnlineWeb.Administration.TableLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.Tables
  alias GameTogetherOnline.Administration.Tables.Table

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :tables, list_tables())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Table")
    |> assign(:table, Tables.get_table!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Table")
    |> assign(:table, %Table{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tables")
    |> assign(:table, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    table = Tables.get_table!(id)
    {:ok, _} = Tables.delete_table(table)

    {:noreply, assign(socket, :tables, list_tables())}
  end

  defp list_tables do
    Tables.list_tables()
  end
end
