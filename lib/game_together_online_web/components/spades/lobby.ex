defmodule GameTogetherOnlineWeb.Components.Spades.Lobby do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div>
      SPADES table <%= @table.id %>
    </div>
    """
  end
end
