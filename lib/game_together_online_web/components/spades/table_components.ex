defmodule GameTogetherOnlineWeb.Spades.TableComponents do
  @behaviour GameTogetherOnlineWeb.TableComponents

  alias GameTogetherOnlineWeb.Components.Spades.Lobby

  def lobby, do: Lobby
end
