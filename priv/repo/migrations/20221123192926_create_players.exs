defmodule GameTogetherOnline.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :nickname, :string

      timestamps()
    end
  end
end
