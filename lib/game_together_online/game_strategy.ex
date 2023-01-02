defmodule GameTogetherOnline.GameStrategy do
  alias GameTogetherOnline.Tables.Table
  alias Ecto.Changeset

  @callback create_table(Dict) :: {:ok, Table} | {:error, Changeset}
  @callback load_game_specific_data(Table) :: Table

  def for_game_type(%{slug: "spades"}), do: GameTogetherOnline.Spades
  def for_game_type(%{slug: "spyfall"}), do: GameTogetherOnline.Spyfall
  def for_game_type(%{slug: "chess"}), do: GameTogetherOnline.Chess
end
