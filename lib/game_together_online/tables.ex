defmodule GameTogetherOnline.Tables do
  @moduledoc """
  The Tables context.
  """

  alias GameTogetherOnline.Repo
  alias GameTogetherOnline.Tables.Table

  def get_table!(id),
    do:
      Table
      |> Repo.get!(id)
      |> Repo.preload(:game_type)

  def create_table(game_type, options) do
    table_factory = factory_for_table(game_type)
    table_factory.create_table(options)
  end

  defp factory_for_table(%{slug: "spades"}), do: GameTogetherOnline.Spades
  defp factory_for_table(%{slug: "spyfall"}), do: GameTogetherOnline.Spyfall
end
