defmodule GameTogetherOnlineWeb.Components.Sidebar do
  use GameTogetherOnlineWeb, :live_component

  alias GameTogetherOnline.ChatMessages.ChatMessage
  alias GameTogetherOnline.PresenceEvents.PresenceEvent

  @impl true
  def render(assigns) do
    ~H"""
    <div class="overflow-hidden w-0 rounded-lg bg-gray-50 lg:w-96 overflow-y-auto h-full border-l border-gray-200 flex flex-col">
      <div class="border-b border-gray-200 bg-white">
        <nav class="-mb-px flex" aria-label="Tabs">
          <button
            phx-click="select_tab"
            phx-value-tab="chat"
            class={tab_class("chat", @current_tab) <> " w-1/2 py-4 px-1 text-center border-b-2 font-medium text-sm"}
          >
            Chat
          </button>

          <button
            href="#"
            phx-click="select_tab"
            phx-value-tab="players_present"
            class={tab_class("players_present", @current_tab) <> " w-1/2 py-4 px-1 text-center border-b-2 font-medium text-sm"}
          >
            Players Present
          </button>
        </nav>
      </div>

      <%= if @current_tab == "chat" do %>
        <%= chat_tab(assigns) %>
      <% else %>
        <%= players_present_tab(assigns) %>
      <% end %>
    </div>
    """
  end

  defp chat_tab(assigns) do
    assigns =
      assign(
        assigns,
        :chat_events,
        Enum.sort_by(assigns.chat.chat_messages ++ assigns.chat.presence_events, & &1.inserted_at)
      )

    ~H"""
    <div class="h-full flex flex-col">
      <div
        class="overflow-y-scroll flex-grow h-0"
        phx-hook="ScrollToBottomOnUpdate"
        id="chat-message-list"
      >
        <.chat_events chat_events={@chat_events} />
      </div>
      <.chat_message_form chat_message={@chat_message} />
    </div>
    """
  end

  defp chat_events(assigns) do
    ~H"""
    <ul role="list" class="-mb-8 px-4 pt-4">
      <%= for chat_event <- @chat_events do %>
        <.chat_event event={chat_event} last={chat_event == List.last(@chat_events)} />
      <% end %>
    </ul>
    """
  end

  defp chat_event(%{event: %ChatMessage{}} = assigns) do
    ~H"""
    <.chat_message chat_message={@event} last={@last} />
    """
  end

  defp chat_event(%{event: %PresenceEvent{}} = assigns) do
    ~H"""
    <.presence_event chat_message={@event} last={@last} />
    """
  end

  defp presence_event(assigns) do
    ~H"""
    <li>
      <div class="relative pb-8">
        <span
          class={[
            "absolute top-5 left-5 -ml-px h-full w-0.5",
            if(@last, do: "", else: "bg-gray-200")
          ]}
          aria-hidden="true"
        >
        </span>
        <div class="relative flex items-start space-x-3">
          <div>
            <div class="relative px-1">
              <div class="flex h-8 w-8 items-center justify-center rounded-full bg-gray-100 ring-8 ring-gray-50">
                <svg
                  class="h-5 w-5 text-gray-500"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 20 20"
                  fill="currentColor"
                  aria-hidden="true"
                >
                  <path
                    fill-rule="evenodd"
                    d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-5.5-2.5a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0zM10 12a5.99 5.99 0 00-4.793 2.39A6.483 6.483 0 0010 16.5a6.483 6.483 0 004.793-2.11A5.99 5.99 0 0010 12z"
                    clip-rule="evenodd"
                  />
                </svg>
              </div>
            </div>
          </div>
          <div class="min-w-0 flex-1 py-1.5">
            <div class="text-sm text-gray-500">
              <a href="#" class="font-medium text-gray-900"><%= @chat_message.player.nickname %></a>
              <%= if @chat_message.type == "join", do: "joined", else: "left" %>
              <span class="whitespace-nowrap">
                <.time_ago
                  timestamp={@chat_message.inserted_at}
                  id={"player-pressnce-inserted-at-#{@chat_message.id}"}
                >
                  --
                </.time_ago>
              </span>
            </div>
          </div>
        </div>
      </div>
    </li>
    """
  end

  defp chat_message_form(assigns) do
    ~H"""
    <.form
      for={@chat_message}
      class="p-4"
      id="chat_message-form"
      phx-submit="create-chat_message"
      phx-hook="SubmitOnEnter"
      data-form-to-submit="chat_message-form"
    >
      <div>
        <label class="sr-only">Chat message</label>
        <div>
          <textarea
            rows="5"
            name="chat_message[content]"
            id="chat_message"
            class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
            placeholder="Add your comment..."
          />
        </div>
      </div>
      <div class="mt-2 flex justify-end">
        <.button
          type="submit"
          class="inline-flex items-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
        >
          Post
        </.button>
      </div>
    </.form>
    """
  end

  defp chat_message(assigns) do
    ~H"""
    <li>
      <div class="relative pb-8">
        <span
          class={[
            "absolute top-5 left-5 -ml-px h-full w-0.5",
            if(@last, do: "", else: "bg-gray-200")
          ]}
          aria-hidden="true"
        >
        </span>
        <div class="relative flex items-start space-x-3">
          <div class="relative">
            <span class="inline-block h-10 w-10 overflow-hidden rounded-full bg-gray-100 ring-8 ring-gray-50">
              <svg class="h-full w-full text-gray-300" fill="currentColor" viewBox="0 0 24 24">
                <path d="M24 20.993V24H0v-2.996A14.977 14.977 0 0112.004 15c4.904 0 9.26 2.354 11.996 5.993zM16.002 8.999a4 4 0 11-8 0 4 4 0 018 0z" />
              </svg>
            </span>

            <span class="absolute -bottom-0.5 -right-1 rounded-tl bg-gray-50 px-0.5 py-px">
              <Heroicons.chat_bubble_left_ellipsis solid class="h-5 w-5 text-gray-400" />
            </span>
          </div>
          <div class="min-w-0 flex-1">
            <div>
              <div class="text-sm">
                <a href="#" class="font-medium text-gray-900">
                  <%= @chat_message.player.nickname %>
                </a>
              </div>
              <p class="mt-0.5 text-sm text-gray-500">
                Commented
                <.time_ago
                  id={"chat-message-inserted-at-#{@chat_message.id}"}
                  timestamp={@chat_message.inserted_at}
                >
                  --
                </.time_ago>
              </p>
            </div>
            <div class="mt-2 text-sm text-gray-700">
              <p>
                <%= @chat_message.content %>
              </p>
            </div>
          </div>
        </div>
      </div>
    </li>
    """
  end

  defp players_present_tab(assigns) do
    ~H"""
    <%= if @players_present == [] do %>
      <div class="h-full flex items-center justify-center">
        <div class="text-center">
          <svg
            class="mx-auto h-12 w-12 text-gray-400"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            aria-hidden="true"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M15.182 16.318A4.486 4.486 0 0012.016 15a4.486 4.486 0 00-3.198 1.318M21 12a9 9 0 11-18 0 9 9 0 0118 0zM9.75 9.75c0 .414-.168.75-.375.75S9 10.164 9 9.75 9.168 9 9.375 9s.375.336.375.75zm-.375 0h.008v.015h-.008V9.75zm5.625 0c0 .414-.168.75-.375.75s-.375-.336-.375-.75.168-.75.375-.75.375.336.375.75zm-.375 0h.008v.015h-.008V9.75z"
            />
          </svg>
          <h3 class="mt-2 text-sm font-medium text-gray-900">There's nobody else here</h3>
          <p class="mt-1 text-sm text-gray-500">Invite some people to play with!</p>
          <div class="mt-6">
            <button
              type="button"
              id="sidebar-copy-invite-link"
              phx-hook="Clipboard"
              data-content={@invite_url}
              data-success-message="Invite Link Copied!"
              class="inline-flex items-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
            >
              Copy Invite Link
            </button>
          </div>
        </div>
      </div>
    <% else %>
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
    <% end %>
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
