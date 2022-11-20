defmodule GameTogetherOnline.GameTypes.GameType do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "game_types" do
    field :description, :string
    field :name, :string
    field :slug, :string

    timestamps()
  end
end
