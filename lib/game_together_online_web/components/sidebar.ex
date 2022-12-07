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
        Current tab: <%= @current_tab %>
      </div>
    </div>
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
