defmodule GameTogetherOnlineWeb.Administration.Spyfall.LocationLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.Spyfall
  alias GameTogetherOnline.Administration.Spyfall.Location

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :locations, list_locations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Location")
    |> assign(:location, Spyfall.get_location!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Location")
    |> assign(:location, %Location{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Locations")
    |> assign(:location, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    location = Spyfall.get_location!(id)
    {:ok, _} = Spyfall.delete_location(location)

    {:noreply, assign(socket, :locations, list_locations())}
  end

  defp list_locations do
    Spyfall.list_locations()
  end
end
