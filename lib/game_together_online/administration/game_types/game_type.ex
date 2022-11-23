defmodule GameTogetherOnline.Administration.GameTypes.GameType do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "game_types" do
    field :description, :string
    field :name, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(game_type, attrs) do
    game_type
    |> cast(attrs, [:name, :description, :slug])
    |> validate_required([:name, :description, :slug])
    |> validate_length(:description, max: 255)
    |> validate_inclusion(:slug, ["spades", "spyfall"])
    |> unique_constraint(:slug)
  end
end
