defmodule GameTogetherOnlineWeb.TableLive.IndexHTML do
  use GameTogetherOnlineWeb, :html

  def lobby_component("spyfall"), do: GameTogetherOnlineWeb.Components.Spyfall.Lobby
  def lobby_component("spades"), do: GameTogetherOnlineWeb.Components.Spades.Lobby
  def lobby_component("chess"), do: GameTogetherOnlineWeb.Components.Chess.Lobby

  embed_templates "index_html/*"
end
