defmodule GameTogetherOnlineWeb.TableComponents do
  @callback lobby() :: LiveComponent

  def for_table(%{game_type: %{slug: "spades"}}), do: GameTogetherOnlineWeb.Spades.TableComponents

  def for_table(%{game_type: %{slug: "spyfall"}}),
    do: GameTogetherOnlineWeb.Spyfall.TableComponents

  def for_table(%{game_type: %{slug: "chess"}}), do: GameTogetherOnlineWeb.Chess.TableComponents
end
