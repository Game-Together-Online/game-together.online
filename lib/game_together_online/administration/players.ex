defmodule GameTogetherOnline.Administration.Players do
  @moduledoc """
  The Players context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Query.Builder.Updates
  alias GameTogetherOnline.Repo

  alias GameTogetherOnline.Administration.Players.Player
  alias GameTogetherOnline.Administration.Players.Updates

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  def list_players do
    Player
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def list_players_without_users_by_nickname(nickname, opts \\ []) do
    player_filter = "%" <> nickname <> "%"
    page_size = Keyword.get(opts, :page_size, 10)

    Repo.all(
      from p in Player,
        left_join: u in assoc(p, :user),
        where: ilike(p.nickname, ^player_filter),
        where: is_nil(u.id),
        limit: ^page_size,
        order_by: [asc: p.nickname]
    )
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id),
    do:
      Player
      |> Repo.get!(id)
      |> Repo.preload(:user)

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
    |> Updates.broadcast()
  end

  @doc """
  Deletes a player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{data: %Player{}}

  """
  def change_player(%Player{} = player, attrs \\ %{}) do
    Player.changeset(player, attrs)
  end

  @spec subscribe_to_updates :: :ok | {:error, {:already_registered, pid}}
  def subscribe_to_updates(), do: Updates.subscribe()
  def subscribe_to_updates(player_id), do: Updates.subscribe(player_id)

  def unsubscribe_from_updates(), do: Updates.unsubscribe()
  def unsubscribe_from_updates(player_id), do: Updates.unsubscribe(player_id)
end
