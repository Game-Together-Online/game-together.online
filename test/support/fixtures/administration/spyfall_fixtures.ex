defmodule GameTogetherOnline.Administration.SpyfallFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameTogetherOnline.Administration.Spyfall` context.
  """

  @doc """
  Generate a location.
  """
  def location_fixture(attrs \\ %{}) do
    {:ok, location} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> GameTogetherOnline.Administration.Spyfall.create_location()

    location
  end
end
