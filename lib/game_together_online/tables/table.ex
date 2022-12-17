defmodule GameTogetherOnline.Tables.Table do
  use Ecto.Schema
  import Ecto.Changeset

  alias GameTogetherOnline.GameTypes.GameType
  alias GameTogetherOnline.Tables.TablePresence

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tables" do
    field :status, :string
    belongs_to :game_type, GameType

    has_many :table_presences, TablePresence
    has_many :players_present, through: [:table_presences, :player]

    timestamps()
  end

  @doc false
  def changeset(table, attrs) do
    table
    |> cast(attrs, [:status, :game_type_id])
    |> validate_required([:status, :game_type_id])
    |> foreign_key_constraint(:game_type_id)
    |> validate_inclusion(:status, [
      "game-pending",
      "game-in-progress",
      "game-finished",
      "game-stopped",
      "game-canceled",
      "game-paused"
    ])
  end
end
