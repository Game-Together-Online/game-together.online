defmodule GameTogetherOnline.Repo.Migrations.CreateGameTypes do
  use Ecto.Migration

  def change do
    create table(:game_types, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :slug, :string

      timestamps()
    end
  end
end
