defmodule GameTogetherOnlineWeb.TableLive.IndexHTML do
  use GameTogetherOnlineWeb, :html

  alias GameTogetherOnlineWeb.TableComponents

  def lobby_component(table) do
    game_component = TableComponents.for_table(table)
    game_component.lobby()
  end

  embed_templates "index_html/*"
end
