defmodule GameTogetherOnlineWeb.Administration.UserLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnline.Administration.Users

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :users, list_users())}
  end

  defp list_users do
    Users.list_users()
  end
end
