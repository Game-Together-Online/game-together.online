defmodule GameTogetherOnline.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset

  @default_name_prefix "Anonymous"

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "players" do
    field :nickname, :string

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:nickname])
    |> validate_required([:nickname])
  end

  def generate_default_nickname() do
    alphabet = Enum.concat([?0..?9, ?A..?Z, ?a..?z])

    default_name_suffix =
      Stream.repeatedly(fn -> Enum.random(alphabet) end)
      |> Enum.take(5)

    "#{@default_name_prefix} #{default_name_suffix}"
  end
end
