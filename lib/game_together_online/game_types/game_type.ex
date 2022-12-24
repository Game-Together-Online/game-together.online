defmodule GameTogetherOnline.GameTypes.GameType do
  use Ecto.Schema
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "game_types" do
    field :description, :string
    field :name, :string
    field :slug, :string
    field :enabled, :boolean

    timestamps(type: :utc_datetime)
  end

  def which_are_enabled(query) do
    from game_type in query,
      where: game_type.enabled == true
  end
end
