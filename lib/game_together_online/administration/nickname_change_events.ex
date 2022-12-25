defmodule GameTogetherOnline.Administration.NicknameChangeEvents do
  @moduledoc """
  The Administration.NicknameChangeEvents context.
  """

  import Ecto.Query, warn: false
  alias GameTogetherOnline.Repo

  alias GameTogetherOnline.Administration.NicknameChangeEvents.NicknameChangeEvent

  @doc """
  Returns the list of nickname_change_events.

  ## Examples

      iex> list_nickname_change_events()
      [%NicknameChangeEvent{}, ...]

  """
  def list_nickname_change_events do
    Repo.all(NicknameChangeEvent)
  end

  @doc """
  Gets a single nickname_change_event.

  Raises `Ecto.NoResultsError` if the Nickname change event does not exist.

  ## Examples

      iex> get_nickname_change_event!(123)
      %NicknameChangeEvent{}

      iex> get_nickname_change_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_nickname_change_event!(id), do: Repo.get!(NicknameChangeEvent, id)

  @doc """
  Creates a nickname_change_event.

  ## Examples

      iex> create_nickname_change_event(%{field: value})
      {:ok, %NicknameChangeEvent{}}

      iex> create_nickname_change_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_nickname_change_event(attrs \\ %{}) do
    %NicknameChangeEvent{}
    |> NicknameChangeEvent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a nickname_change_event.

  ## Examples

      iex> update_nickname_change_event(nickname_change_event, %{field: new_value})
      {:ok, %NicknameChangeEvent{}}

      iex> update_nickname_change_event(nickname_change_event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_nickname_change_event(%NicknameChangeEvent{} = nickname_change_event, attrs) do
    nickname_change_event
    |> NicknameChangeEvent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a nickname_change_event.

  ## Examples

      iex> delete_nickname_change_event(nickname_change_event)
      {:ok, %NicknameChangeEvent{}}

      iex> delete_nickname_change_event(nickname_change_event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_nickname_change_event(%NicknameChangeEvent{} = nickname_change_event) do
    Repo.delete(nickname_change_event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking nickname_change_event changes.

  ## Examples

      iex> change_nickname_change_event(nickname_change_event)
      %Ecto.Changeset{data: %NicknameChangeEvent{}}

  """
  def change_nickname_change_event(%NicknameChangeEvent{} = nickname_change_event, attrs \\ %{}) do
    NicknameChangeEvent.changeset(nickname_change_event, attrs)
  end
end
