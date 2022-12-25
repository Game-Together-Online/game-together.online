defmodule GameTogetherOnline.Administration.NicknameChangeEvents.NicknameChangeEvent do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "nickname_change_events" do
    field :new_nickname, :string
    field :original_nickname, :string
    field :player_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(nickname_change_event, attrs) do
    nickname_change_event
    |> cast(attrs, [:original_nickname, :new_nickname, :player_id])
    |> validate_required([:original_nickname, :new_nickname, :player_id])
    |> foreign_key_constraint(:player_id)
  end
end
