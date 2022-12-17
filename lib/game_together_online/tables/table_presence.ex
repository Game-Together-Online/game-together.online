defmodule GameTogetherOnline.Tables.TablePresence do
  alias GameTogetherOnlineWeb.Player
  use Ecto.Schema
  import Ecto.Changeset

  alias GameTogetherOnline.Tables.Table
  alias GameTogetherOnline.Players.Player

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "table_presences" do
    belongs_to :player, Player
    belongs_to :table, Table

    timestamps()
  end

  @doc false
  def changeset(table_presence, attrs) do
    table_presence
    |> cast(attrs, [:player_id, :table_id])
    |> validate_required([:player_id, :table_id])
    |> foreign_key_constraint(:player_id)
    |> foreign_key_constraint(:table_id)
    |> unique_constraint([:player_id, :table_id])
  end
end
