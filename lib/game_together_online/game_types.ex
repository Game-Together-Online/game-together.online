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

  def get_game_type_by_slug!(slug) do
    Repo.get_by!(GameType, slug: slug)
  end
end
