defmodule GameTogetherOnline.Administration.SpyfallGames.SpyfallGame do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "spyfall_games" do
    field :table_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(spyfall_game, attrs) do
    spyfall_game
    |> cast(attrs, [:table_id])
    |> validate_required([:table_id])
    |> foreign_key_constraint(:table_id)
  end
end
