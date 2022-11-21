defmodule GameTogetherOnline.Spades do
  @moduledoc """
  The Spades context.
  """

  alias GameTogetherOnline.Tables.Table
  alias GameTogetherOnline.GameTypes
  alias GameTogetherOnline.Repo

  @game_type_slug "spades"

  # TODO: Test this
  def create_table(_options \\ %{}) do
    %Table{}
    |> Table.changeset(%{status: "game-pending", game_type_id: load_game_type_id()})
    |> Repo.insert()
  end

  defp load_game_type_id do
    @game_type_slug
    |> GameTypes.get_game_type_by_slug!()
    |> Map.get(:id)
  end
end
