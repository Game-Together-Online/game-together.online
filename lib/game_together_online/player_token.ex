defmodule GameTogetherOnline.PlayerToken do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "player_tokens" do
    field :token, :binary
    field :player_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(player_token, attrs) do
    player_token
    |> cast(attrs, [:token, :player_id])
    |> validate_required([:token, :player_id])
    |> foreign_key_constraint(:player_id)
  end
end
