defmodule GameTogetherOnlineWeb.Components.Sidebar do
  use Phoenix.LiveComponent

  @default_tab :chat

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :current_tab, @default_tab)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="overflow-hidden w-0 rounded-lg bg-gray-50 lg:w-96 overflow-y-auto h-full border-l border-gray-200">
      <div>
        <div class="border-b border-gray-200 bg-white">
          <nav class="-mb-px flex" aria-label="Tabs">
            <button
              phx-click="select_tab"
              phx-value-tab={:chat}
              phx-target={@myself}
              class={tab_class(:chat, @current_tab) <> " w-1/2 py-4 px-1 text-center border-b-2 font-medium text-sm"}
            >
              Chat
            </button>

            <button
              href="#"
              phx-click="select_tab"
              phx-value-tab={:players_present}
              phx-target={@myself}
              class={tab_class(:players_present, @current_tab) <> " w-1/2 py-4 px-1 text-center border-b-2 font-medium text-sm"}
            >
              Players Present
            </button>
          </nav>
        </div>

        <%= if @current_tab == :chat do %>
          <%= chat_tab(assigns) %>
        <% else %>
          <%= players_present_tab(assigns) %>
        <% end %>
      </div>
    </div>
    """
  end

  defp chat_tab(assigns) do
    ~H"""
    Current tab: chat
    """
  end

  defp players_present_tab(assigns) do
    ~H"""
    <ul role="list" class="divide-y divide-gray-200">
      <%= for player_present <- @players_present do %>
        <li class="flex items-center justify-between space-x-3 py-4 px-4">
          <div class="flex min-w-0 flex-1 items-center space-x-3">
            <div class="flex-shrink-0">
              <span class="inline-block h-10 w-10 overflow-hidden rounded-full bg-gray-100">
                <svg class="h-full w-full text-gray-300" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M24 20.993V24H0v-2.996A14.977 14.977 0 0112.004 15c4.904 0 9.26 2.354 11.996 5.993zM16.002 8.999a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
              </span>
            </div>
            <p class="truncate text-sm font-medium text-gray-900"><%= player_present.nickname %></p>
          </div>
        </li>
      <% end %>
    </ul>
    """
  end

  @impl true
  def handle_event("select_tab", %{"tab" => "players_present"}, socket),
    do: {:noreply, assign(socket, :current_tab, :players_present)}

  def handle_event("select_tab", %{"tab" => "chat"}, socket),
    do: {:noreply, assign(socket, :current_tab, :chat)}

  defp tab_class(tab, tab), do: "border-indigo-500 text-indigo-600"

  defp tab_class(_, _),
    do: "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300"
end
