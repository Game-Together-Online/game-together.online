defmodule GameTogetherOnline.Administration.TablesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameTogetherOnline.Administration.Tables` context.
  """

  @doc """
  Generate a table.
  """
  def table_fixture(attrs \\ %{}) do
    {:ok, table} =
      attrs
      |> Enum.into(%{
        status: "game-pending"
      })
      |> GameTogetherOnline.Administration.Tables.create_table()

    table
  end
end
