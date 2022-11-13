defmodule GameTogetherOnline.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:tables, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :status, :string

      timestamps()
    end
  end
end
