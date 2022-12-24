defmodule GameTogetherOnline.Repo.Migrations.CreateSpyfallGames do
  use Ecto.Migration

  def change do
    create table(:spyfall_games, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :table_id, references(:tables, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:spyfall_games, [:table_id])
  end
end
