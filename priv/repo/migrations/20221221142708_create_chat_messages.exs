defmodule GameTogetherOnline.Repo.Migrations.CreateChatMessages do
  use Ecto.Migration

  def change do
    create table(:chat_messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :string
      add :chat_id, references(:chats, on_delete: :nothing, type: :binary_id)
      add :player_id, references(:players, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:chat_messages, [:chat_id])
    create index(:chat_messages, [:player_id])
  end
end
