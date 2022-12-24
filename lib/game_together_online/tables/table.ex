defmodule GameTogetherOnline.Tables.Table do
  use Ecto.Schema
  import Ecto.Changeset

  alias GameTogetherOnline.GameTypes.GameType
  alias GameTogetherOnline.Tables.TablePresence
  alias GameTogetherOnline.Chats.Chat
  alias GameTogetherOnline.SpyfallGames.SpyfallGame

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tables" do
    field :status, :string
    belongs_to :game_type, GameType

    has_many :table_presences, TablePresence
    has_many :players_present, through: [:table_presences, :player]

    has_one :chat, Chat
    has_one :spyfall_game, SpyfallGame

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(table, attrs) do
    spyfall_game = Map.get(attrs, :spyfall_game, nil)

    table
    |> cast(attrs, [:status, :game_type_id])
    |> validate_required([:status, :game_type_id])
    |> foreign_key_constraint(:game_type_id)
    |> put_assoc(:chat, attrs.chat)
    |> put_assoc(:spyfall_game, spyfall_game)
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
