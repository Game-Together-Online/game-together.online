defmodule GameTogetherOnline.Administration.Tables.Table do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tables" do
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(table, attrs) do
    table
    |> cast(attrs, [:status])
    |> validate_required([:status])
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
