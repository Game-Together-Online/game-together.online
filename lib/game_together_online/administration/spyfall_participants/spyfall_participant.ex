defmodule GameTogetherOnline.Administration.SpyfallParticipants.SpyfallParticipant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "spyfall_participants" do
    field :ready_to_start, :boolean, default: false
    field :player_id, :binary_id
    field :spyfall_game_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(spyfall_participant, attrs) do
    spyfall_participant
    |> cast(attrs, [:ready_to_start, :player_id, :spyfall_game_id])
    |> validate_required([:ready_to_start, :player_id, :spyfall_game_id])
  end
end
