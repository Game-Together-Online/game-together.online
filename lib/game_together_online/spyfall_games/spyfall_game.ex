defmodule GameTogetherOnline.SpyfallGames.SpyfallGame do
  use Ecto.Schema
  import Ecto.Changeset

  alias GameTogetherOnline.Tables.Table
  alias GameTogetherOnline.SpyfallParticipants.SpyfallParticipant

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "spyfall_games" do
    belongs_to :table, Table

    has_many :spyfall_participants, SpyfallParticipant

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(spyfall_game, attrs) do
    spyfall_game
    |> cast(attrs, [:table_id])
    |> validate_required([:table_id])
    |> foreign_key_constraint(:table_id)
  end
end
