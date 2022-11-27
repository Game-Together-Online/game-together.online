defmodule GameTogetherOnline.Repo.Migrations.CreateSpyfallLocations do
  use Ecto.Migration

  def change do
    create table(:spyfall_locations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      timestamps()
    end

    create unique_index(:spyfall_locations, [:name])
  end
end
