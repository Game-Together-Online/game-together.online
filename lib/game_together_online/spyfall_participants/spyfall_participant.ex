defmodule GameTogetherOnline.SpyfallParticipants.SpyfallParticipant do
  use Ecto.Schema
  import Ecto.Changeset

  alias GameTogetherOnline.SpyfallGames.SpyfallGame
  alias GameTogetherOnline.Players.Player

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "spyfall_participants" do
    field :ready_to_start, :boolean, default: false

    belongs_to :spyfall_game, SpyfallGame
    belongs_to :player, Player

    timestamps()
  end

  @doc false
  def changeset(spyfall_participant, attrs) do
    spyfall_participant
    |> cast(attrs, [:ready_to_start, :player_id, :spyfall_game_id])
    |> validate_required([:ready_to_start, :player_id, :spyfall_game_id])
  end
end
