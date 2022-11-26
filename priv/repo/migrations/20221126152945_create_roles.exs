defmodule GameTogetherOnline.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :slug, :string

      timestamps()
    end

    create unique_index(:roles, [:slug])
  end
end
