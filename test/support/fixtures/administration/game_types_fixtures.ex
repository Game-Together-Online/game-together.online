defmodule GameTogetherOnline.Administration.GameTypesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameTogetherOnline.GameTypes` context.
  """

  @doc """
  Generate a game_type.
  """
  def game_type_fixture(attrs \\ %{}) do
    {:ok, game_type} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        slug: "some slug"
      })
      |> GameTogetherOnline.Administration.GameTypes.create_game_type()

    game_type
  end
end
