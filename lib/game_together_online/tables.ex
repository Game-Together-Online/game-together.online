defmodule GameTogetherOnline.Tables do
  @moduledoc """
  The Tables context.
  """

  def create_table(game_type, options) do
    table_factory = factory_for_table(game_type)
    table_factory.create_table(options)
  end

  defp factory_for_table(%{slug: "spades"}), do: GameTogetherOnline.Spades
end
