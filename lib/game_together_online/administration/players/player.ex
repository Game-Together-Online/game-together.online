defmodule GameTogetherOnline.Administration.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "players" do
    field :nickname, :string

    belongs_to :user, GameTogetherOnline.Administration.Users.User

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:nickname, :user_id])
    |> validate_required([:nickname])
  end
end
