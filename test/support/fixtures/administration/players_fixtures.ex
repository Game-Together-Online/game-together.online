defmodule GameTogetherOnline.Administration.PlayersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameTogetherOnline.Players` context.
  """

  @doc """
  Generate a player.
  """
  def player_fixture(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
        nickname: "some nickname"
      })
      |> GameTogetherOnline.Administration.Players.create_player()

    player
  end
end
