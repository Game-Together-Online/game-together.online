defmodule GameTogetherOnline.Administration.TablesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameTogetherOnline.Administration.Tables` context.
  """

  import GameTogetherOnline.Administration.GameTypesFixtures

  @doc """
  Generate a table.
  """
  def table_fixture(attrs \\ %{}) do
    game_type = game_type_fixture()

    {:ok, table} =
      attrs
      |> Enum.into(%{
        status: "game-pending",
        game_type_id: game_type.id
      })
      |> GameTogetherOnline.Administration.Tables.create_table()

    table
  end
end
