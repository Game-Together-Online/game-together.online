defmodule GameTogetherOnline.Administration.SpyfallGames do
  @moduledoc """
  The Administration.SpyfallGames context.
  """

  import Ecto.Query, warn: false
  alias GameTogetherOnline.Repo

  alias GameTogetherOnline.Administration.SpyfallGames.SpyfallGame

  @doc """
  Returns the list of spyfall_games.

  ## Examples

      iex> list_spyfall_games()
      [%SpyfallGame{}, ...]

  """
  def list_spyfall_games do
    Repo.all(SpyfallGame)
  end

  @doc """
  Gets a single spyfall_game.

  Raises `Ecto.NoResultsError` if the Spyfall game does not exist.

  ## Examples

      iex> get_spyfall_game!(123)
      %SpyfallGame{}

      iex> get_spyfall_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_spyfall_game!(id), do: Repo.get!(SpyfallGame, id)

  @doc """
  Creates a spyfall_game.

  ## Examples

      iex> create_spyfall_game(%{field: value})
      {:ok, %SpyfallGame{}}

      iex> create_spyfall_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_spyfall_game(attrs \\ %{}) do
    %SpyfallGame{}
    |> SpyfallGame.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a spyfall_game.

  ## Examples

      iex> update_spyfall_game(spyfall_game, %{field: new_value})
      {:ok, %SpyfallGame{}}

      iex> update_spyfall_game(spyfall_game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_spyfall_game(%SpyfallGame{} = spyfall_game, attrs) do
    spyfall_game
    |> SpyfallGame.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a spyfall_game.

  ## Examples

      iex> delete_spyfall_game(spyfall_game)
      {:ok, %SpyfallGame{}}

      iex> delete_spyfall_game(spyfall_game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_spyfall_game(%SpyfallGame{} = spyfall_game) do
    Repo.delete(spyfall_game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking spyfall_game changes.

  ## Examples

      iex> change_spyfall_game(spyfall_game)
      %Ecto.Changeset{data: %SpyfallGame{}}

  """
  def change_spyfall_game(%SpyfallGame{} = spyfall_game, attrs \\ %{}) do
    SpyfallGame.changeset(spyfall_game, attrs)
  end
end
