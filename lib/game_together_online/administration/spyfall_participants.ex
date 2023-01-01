defmodule GameTogetherOnline.Administration.SpyfallParticipants do
  @moduledoc """
  The Administration.SpyfallParticipants context.
  """

  import Ecto.Query, warn: false
  alias GameTogetherOnline.Repo

  alias GameTogetherOnline.Administration.SpyfallParticipants.SpyfallParticipant

  @doc """
  Returns the list of spyfall_participants.

  ## Examples

      iex> list_spyfall_participants()
      [%SpyfallParticipant{}, ...]

  """
  def list_spyfall_participants do
    Repo.all(SpyfallParticipant)
  end

  @doc """
  Gets a single spyfall_participant.

  Raises `Ecto.NoResultsError` if the Spyfall participant does not exist.

  ## Examples

      iex> get_spyfall_participant!(123)
      %SpyfallParticipant{}

      iex> get_spyfall_participant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_spyfall_participant!(id), do: Repo.get!(SpyfallParticipant, id)

  @doc """
  Creates a spyfall_participant.

  ## Examples

      iex> create_spyfall_participant(%{field: value})
      {:ok, %SpyfallParticipant{}}

      iex> create_spyfall_participant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_spyfall_participant(attrs \\ %{}) do
    %SpyfallParticipant{}
    |> SpyfallParticipant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a spyfall_participant.

  ## Examples

      iex> update_spyfall_participant(spyfall_participant, %{field: new_value})
      {:ok, %SpyfallParticipant{}}

      iex> update_spyfall_participant(spyfall_participant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_spyfall_participant(%SpyfallParticipant{} = spyfall_participant, attrs) do
    spyfall_participant
    |> SpyfallParticipant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a spyfall_participant.

  ## Examples

      iex> delete_spyfall_participant(spyfall_participant)
      {:ok, %SpyfallParticipant{}}

      iex> delete_spyfall_participant(spyfall_participant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_spyfall_participant(%SpyfallParticipant{} = spyfall_participant) do
    Repo.delete(spyfall_participant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking spyfall_participant changes.

  ## Examples

      iex> change_spyfall_participant(spyfall_participant)
      %Ecto.Changeset{data: %SpyfallParticipant{}}

  """
  def change_spyfall_participant(%SpyfallParticipant{} = spyfall_participant, attrs \\ %{}) do
    SpyfallParticipant.changeset(spyfall_participant, attrs)
  end
end
