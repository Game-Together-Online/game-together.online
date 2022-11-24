defmodule GameTogetherOnline.PlayerToken do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias __MODULE__
  alias GameTogetherOnline.Players.Player

  @rand_size 32

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "player_tokens" do
    field :token, :binary
    belongs_to :player, Player

    timestamps()
  end

  @doc false
  def changeset(player_token, attrs) do
    player_token
    |> cast(attrs, [:token, :player_id])
    |> validate_required([:token, :player_id])
    |> foreign_key_constraint(:player_id)
  end

  def build_session_token(player) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %PlayerToken{token: token, player_id: player.id}}
  end

  def verify_session_token_query(token) do
    query =
      from t in PlayerToken,
        join: user in assoc(t, :player),
        where: [token: ^token],
        select: user

    {:ok, query}
  end
end
