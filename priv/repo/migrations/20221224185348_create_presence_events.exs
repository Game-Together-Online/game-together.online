defmodule GameTogetherOnline.Repo.Migrations.CreatePresenceEvents do
  use Ecto.Migration

  def change do
    create table(:presence_events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string
      add :chat_id, references(:chats, on_delete: :nothing, type: :binary_id)
      add :player_id, references(:players, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:presence_events, [:chat_id])
    create index(:presence_events, [:player_id])
  end
end
