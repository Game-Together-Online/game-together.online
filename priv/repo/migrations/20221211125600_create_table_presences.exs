defmodule GameTogetherOnline.Repo.Migrations.CreateTablePresences do
  use Ecto.Migration

  def change do
    create table(:table_presences, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :player_id, references(:players, on_delete: :nothing, type: :binary_id), null: false
      add :table_id, references(:tables, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:table_presences, [:player_id])
    create index(:table_presences, [:table_id])
    create unique_index(:table_presences, [:player_id, :table_id])
  end
end
