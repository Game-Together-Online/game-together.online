defmodule GameTogetherOnline.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :table_id, references(:tables, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:chats, [:table_id])
  end
end
