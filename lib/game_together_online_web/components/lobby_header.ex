defmodule GameTogetherOnlineWeb.Components.LobbyHeader do
  use GameTogetherOnlineWeb, :live_component

  slot :actions

  @impl true
  def render(assigns) do
    ~H"""
    <div class="md:flex md:items-center md:justify-between md:space-x-5">
      <div class="flex items-start space-x-5">
        <div class="flex-shrink-0">
          <div class="relative">
            <span class="inline-block h-16 w-16 overflow-hidden rounded-full bg-gray-100">
              <svg class="h-full w-full text-gray-300" fill="currentColor" viewBox="0 0 24 24">
                <path d="M24 20.993V24H0v-2.996A14.977 14.977 0 0112.004 15c4.904 0 9.26 2.354 11.996 5.993zM16.002 8.999a4 4 0 11-8 0 4 4 0 018 0z" />
              </svg>
            </span>
            <span class="absolute inset-0 rounded-full shadow-inner" aria-hidden="true"></span>
          </div>
        </div>
        <div class="pt-1.5">
          <p class="text-sm font-medium text-gray-600">Welcome to the game,</p>
          <p class="text-xl font-bold text-gray-900 sm:text-2xl flex items-center">
            <%= @current_player.nickname %>
          </p>
        </div>
      </div>
      <div class="justify-stretch mt-6 flex flex-col-reverse space-y-4 space-y-reverse sm:flex-row-reverse sm:justify-end sm:space-y-0 sm:space-x-3 sm:space-x-reverse md:mt-0 md:flex-row md:space-x-3">
        <%= if @actions do %>
          <%= render_slot(@actions) %>
        <% end %>
      </div>
    </div>
    """
  end
end
