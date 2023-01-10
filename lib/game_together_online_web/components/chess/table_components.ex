defmodule GameTogetherOnlineWeb.Chess.TableComponents do
  @behaviour GameTogetherOnlineWeb.TableComponents

  alias GameTogetherOnlineWeb.Components.Chess.Lobby

  def lobby, do: Lobby
end
