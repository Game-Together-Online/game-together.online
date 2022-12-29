defmodule GameTogetherOnline.NicknameChangeEvents.NicknameChangeChatEvent do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "nickname_change_chat_events" do
    field :chat_id, :binary_id
    field :nickname_change_event_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(nickname_change_chat_event, attrs) do
    nickname_change_chat_event
    |> cast(attrs, [:chat_id, :nickname_change_event_id])
    |> validate_required([:chat_id, :nickname_change_event_id])
    |> foreign_key_constraint(:chat_id)
    |> foreign_key_constraint(:nickname_change_event_id)
  end
end
