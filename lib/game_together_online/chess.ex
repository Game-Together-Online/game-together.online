defmodule GameTogetherOnline.Chess do
  @behaviour GameTogetherOnline.GameStrategy
  @moduledoc """
  The Chess context.
  """

  alias GameTogetherOnline.Tables.Table
  alias GameTogetherOnline.GameTypes
  alias GameTogetherOnline.Repo

  @game_type_slug "chess"

  def load_game_specific_data(table), do: table

  def create_table(_options) do
    %Table{}
    |> Table.changeset(%{status: "game-pending", game_type_id: load_game_type_id(), chat: %{}})
    |> Repo.insert()
  end

  defp load_game_type_id do
    @game_type_slug
    |> GameTypes.get_game_type_by_slug!()
    |> Map.get(:id)
  end
end
