defmodule GameTogetherOnline.Repo.Migrations.AddGameTypeIdToTables do
  use Ecto.Migration

  def change do
    alter table("tables") do
      add :game_type_id, references(:game_types, type: :binary_id, on_delete: :delete_all),
        null: false
    end

    create index(:tables, [:game_type_id])
    create unique_index(:game_types, [:slug])
  end
end
