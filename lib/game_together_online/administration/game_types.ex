defmodule GameTogetherOnline.Administration.GameTypes do
  @moduledoc """
  The GameTypes context.
  """

  import Ecto.Query, warn: false
  alias GameTogetherOnline.Repo

  alias GameTogetherOnline.Administration.GameTypes.GameType

  @doc """
  Returns the list of game_types.

  ## Examples

      iex> list_game_types()
      [%GameType{}, ...]

  """
  def list_game_types do
    Repo.all(GameType)
  end

  @doc """
  Gets a single game_type.

  Raises `Ecto.NoResultsError` if the Game type does not exist.

  ## Examples

      iex> get_game_type!(123)
      %GameType{}

      iex> get_game_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game_type!(id), do: Repo.get!(GameType, id)

  @doc """
  Creates a game_type.

  ## Examples

      iex> create_game_type(%{field: value})
      {:ok, %GameType{}}

      iex> create_game_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game_type(attrs \\ %{}) do
    %GameType{}
    |> GameType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game_type.

  ## Examples

      iex> update_game_type(game_type, %{field: new_value})
      {:ok, %GameType{}}

      iex> update_game_type(game_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game_type(%GameType{} = game_type, attrs) do
    game_type
    |> GameType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game_type.

  ## Examples

      iex> delete_game_type(game_type)
      {:ok, %GameType{}}

      iex> delete_game_type(game_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game_type(%GameType{} = game_type) do
    Repo.delete(game_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game_type changes.

  ## Examples

      iex> change_game_type(game_type)
      %Ecto.Changeset{data: %GameType{}}

  """
  def change_game_type(%GameType{} = game_type, attrs \\ %{}) do
    GameType.changeset(game_type, attrs)
  end
end
