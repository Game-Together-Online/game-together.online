defmodule GameTogetherOnline.Administration.PresenceEvents do
  @moduledoc """
  The Administration.PresenceEvents context.
  """

  import Ecto.Query, warn: false
  alias GameTogetherOnline.Repo

  alias GameTogetherOnline.Administration.PresenceEvents.PresenceEvent

  @doc """
  Returns the list of presence_events.

  ## Examples

      iex> list_presence_events()
      [%PresenceEvent{}, ...]

  """
  def list_presence_events do
    Repo.all(PresenceEvent)
  end

  @doc """
  Gets a single presence_event.

  Raises `Ecto.NoResultsError` if the Presence event does not exist.

  ## Examples

      iex> get_presence_event!(123)
      %PresenceEvent{}

      iex> get_presence_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_presence_event!(id), do: Repo.get!(PresenceEvent, id)

  @doc """
  Creates a presence_event.

  ## Examples

      iex> create_presence_event(%{field: value})
      {:ok, %PresenceEvent{}}

      iex> create_presence_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_presence_event(attrs \\ %{}) do
    %PresenceEvent{}
    |> PresenceEvent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a presence_event.

  ## Examples

      iex> update_presence_event(presence_event, %{field: new_value})
      {:ok, %PresenceEvent{}}

      iex> update_presence_event(presence_event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_presence_event(%PresenceEvent{} = presence_event, attrs) do
    presence_event
    |> PresenceEvent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a presence_event.

  ## Examples

      iex> delete_presence_event(presence_event)
      {:ok, %PresenceEvent{}}

      iex> delete_presence_event(presence_event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_presence_event(%PresenceEvent{} = presence_event) do
    Repo.delete(presence_event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking presence_event changes.

  ## Examples

      iex> change_presence_event(presence_event)
      %Ecto.Changeset{data: %PresenceEvent{}}

  """
  def change_presence_event(%PresenceEvent{} = presence_event, attrs \\ %{}) do
    PresenceEvent.changeset(presence_event, attrs)
  end
end
