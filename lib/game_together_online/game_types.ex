defmodule GameTogetherOnline.GameTypes do
  alias GameTogetherOnline.GameTypes.GameType
  alias GameTogetherOnline.Repo

  @doc """
  Returns the list of game_types.

  ## Examples

      iex> list_game_types()
      [%GameType{}, ...]

  """
  def list_game_types do
    Repo.all(GameType)
  end
end
