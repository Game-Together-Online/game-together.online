defmodule GameTogetherOnline.SpyfallParticipants do
  alias GameTogetherOnline.SpyfallParticipants.SpyfallParticipant
  alias GameTogetherOnline.Repo

  def create_spyfall_participant(attrs \\ %{}) do
    %SpyfallParticipant{}
    |> SpyfallParticipant.changeset(attrs)
    |> Repo.insert()
  end
end
