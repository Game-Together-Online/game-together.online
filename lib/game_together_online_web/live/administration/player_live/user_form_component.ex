defmodule GameTogetherOnlineWeb.Administration.PlayerLive.UserFormComponent do
  use GameTogetherOnlineWeb, :live_component

  alias GameTogetherOnline.Administration.Users
  alias GameTogetherOnline.Administration.Players

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(
       :users,
       list_users("")
     )
     |> assign(:email_filter, "")}
  end

  @impl true
  def render(%{users: [], email_filter: ""} = assigns) do
    ~H"""
    <div class="mx-auto max-w-lg">OOPS! No users found.</div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-lg">
      <div>
        <div class="text-center">
          <svg
            class="mx-auto h-12 w-12 text-gray-400"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 48 48"
            aria-hidden="true"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M34 40h10v-4a6 6 0 00-10.712-3.714M34 40H14m20 0v-4a9.971 9.971 0 00-.712-3.714M14 40H4v-4a6 6 0 0110.713-3.714M14 40v-4c0-1.313.253-2.566.713-3.714m0 0A10.003 10.003 0 0124 26c4.21 0 7.813 2.602 9.288 6.286M30 14a6 6 0 11-12 0 6 6 0 0112 0zm12 6a4 4 0 11-8 0 4 4 0 018 0zm-28 0a4 4 0 11-8 0 4 4 0 018 0z"
            />
          </svg>
          <h2 class="mt-2 text-lg font-medium text-gray-900">Associate a user</h2>
          <p class="mt-1 text-sm text-gray-500">
            There hasn't been a user associated with this player yet.
          </p>
        </div>
        <.simple_form
          :let={f}
          for={:user}
          id="user-email-form"
          phx-target={@myself}
          phx-change="filter_users"
        >
          <.input field={{f, :email}} type="email" placeholder="Enter an email" />
        </.simple_form>
      </div>
      <div class="mt-10">
        <h3 class="text-sm font-medium text-gray-500">
          Users who have not been assigned a player.
        </h3>
        <%= user_list(assigns) %>
      </div>
    </div>
    """
  end

  def user_list(%{users: []} = assigns) do
    ~H"""
    <h3 class="text-xs font-medium text-gray-500 mt-4">
      No users without a player were found with an email that matches "<%= @email_filter %>".
    </h3>
    """
  end

  def user_list(assigns) do
    ~H"""
    <ul role="list" class="mt-4 divide-y divide-gray-200 border-t border-b border-gray-200">
      <%= for user <- @users do %>
        <li class="flex items-center justify-between space-x-3 py-4">
          <div class="min-w-0 flex-1">
            <p class="truncate text-sm font-medium text-gray-900"><%= user.email %></p>
          </div>
          <div class="flex-shrink-0">
            <button
              phx-target={@myself}
              phx-click="associate_user"
              phx-value-user_id={user.id}
              type="button"
              class="inline-flex items-center rounded-full border border-transparent bg-gray-100 py-2 px-3 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
            >
              <svg
                class="-ml-1 mr-0.5 h-5 w-5 text-gray-400"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 20 20"
                fill="currentColor"
                aria-hidden="true"
              >
                <path d="M10.75 4.75a.75.75 0 00-1.5 0v4.5h-4.5a.75.75 0 000 1.5h4.5v4.5a.75.75 0 001.5 0v-4.5h4.5a.75.75 0 000-1.5h-4.5v-4.5z" />
              </svg>
              <span class="text-sm font-medium text-gray-900">
                Assign <span class="sr-only"><%= user.email %></span>
              </span>
            </button>
          </div>
        </li>
      <% end %>
    </ul>
    """
  end

  @impl true
  def handle_event("filter_users", %{"user" => %{"email" => email}}, socket) do
    {:noreply,
     socket
     |> assign(:users, list_users(email))
     |> assign(:email_filter, email)}
  end

  # TODO: Test this
  def handle_event("associate_user", %{"user_id" => user_id}, socket) do
    %{player: player} = socket.assigns
    {:ok, _player} = Players.update_player(player, %{user_id: user_id})

    {:noreply, socket}
  end

  defp list_users(email) do
    Users.list_users_without_players_by_email(email, limit: 5)
  end
end
