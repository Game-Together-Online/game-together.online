defmodule GameTogetherOnline.Repo.Migrations.CreateNicknameChangeChatEvents do
  use Ecto.Migration

  def change do
    create table(:nickname_change_chat_events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :chat_id, references(:chats, on_delete: :nothing, type: :binary_id)

      add :nickname_change_event_id,
          references(:nickname_change_events, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:nickname_change_chat_events, [:chat_id])
    create index(:nickname_change_chat_events, [:nickname_change_event_id])
  end
end
