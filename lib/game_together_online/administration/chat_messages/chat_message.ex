defmodule GameTogetherOnline.Administration.ChatMessages.ChatMessage do
  use Ecto.Schema
  import Ecto.Changeset

  alias GameTogetherOnline.Administration.Chats.Chat
  alias GameTogetherOnline.Administration.Players.Player

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chat_messages" do
    field :content, :string

    belongs_to :chat, Chat
    belongs_to :player, Player

    timestamps()
  end

  @doc false
  def changeset(chat_message, attrs) do
    chat_message
    |> cast(attrs, [:content, :chat_id, :player_id])
    |> validate_required([:content, :chat_id, :player_id])
    |> foreign_key_constraint(:chat_id)
    |> foreign_key_constraint(:player_id)
  end
end
