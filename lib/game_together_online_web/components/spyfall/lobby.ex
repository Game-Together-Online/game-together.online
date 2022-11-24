defmodule GameTogetherOnlineWeb.Components.Spyfall.Lobby do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div>
      SPYFALL! <%= @table.id %>
    </div>
    """
  end
end
