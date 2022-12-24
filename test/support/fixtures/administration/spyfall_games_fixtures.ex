defmodule GameTogetherOnline.Administration.SpyfallGamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameTogetherOnline.Administration.SpyfallGames` context.
  """

  @doc """
  Generate a spyfall_game.
  """
  def spyfall_game_fixture(attrs \\ %{}) do
    {:ok, spyfall_game} =
      attrs
      |> Enum.into(%{})
      |> GameTogetherOnline.Administration.SpyfallGames.create_spyfall_game()

    spyfall_game
  end
end
