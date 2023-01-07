defmodule GameTogetherOnline.SpyfallParticipants do
  import Ecto.Query

  alias GameTogetherOnline.SpyfallParticipants.SpyfallParticipant
  alias GameTogetherOnline.Repo

  def toggle_readiness(spyfall_participant) do
    spyfall_participant
    |> SpyfallParticipant.changeset(%{ready_to_start: !spyfall_participant.ready_to_start})
    |> Repo.update()
  end

  def delete_spyfall_participant_by_game_and_player(game_id, player_id) do
    SpyfallParticipant
    |> where(
      [spyfall_participant],
      spyfall_participant.player_id == ^player_id and
        spyfall_participant.spyfall_game_id == ^game_id
    )
    |> Repo.delete_all()
  end

  def create_spyfall_participant(attrs \\ %{}) do
    %SpyfallParticipant{}
    |> SpyfallParticipant.changeset(attrs)
    |> Repo.insert()
  end
end
