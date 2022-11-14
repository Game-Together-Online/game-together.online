defmodule GameTogetherOnlineWeb.TableLive.Index do
  use GameTogetherOnlineWeb, :live_view

  alias GameTogetherOnlineWeb.TableLive.IndexHTML

  def render(%{live_action: :lobby} = assigns), do: IndexHTML.lobby(assigns)
end
