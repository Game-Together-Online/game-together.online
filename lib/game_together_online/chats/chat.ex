defmodule GameTogetherOnline.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  alias GameTogetherOnline.Administration.Tables.Table
  alias GameTogetherOnline.ChatMessages.ChatMessage
  alias GameTogetherOnline.PresenceEvents.PresenceEvent
  alias GameTogetherOnline.NicknameChangeEvents.NicknameChangeChatEvent

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chats" do
    belongs_to :table, Table

    has_many :chat_messages, ChatMessage
    has_many :presence_events, PresenceEvent
    has_many :nickname_change_chat_events, NicknameChangeChatEvent

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:table_id])
    |> validate_required([:table_id])
    |> foreign_key_constraint(:table_id)
  end
end
