defmodule GameTogetherOnlineWeb.Components.Chess.Lobby do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div>
      CHESS table <%= @table.id %>
    </div>
    """
  end
end
