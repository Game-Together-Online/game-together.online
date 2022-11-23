defmodule GameTogetherOnline.Repo.Migrations.CreatePlayerTokens do
  use Ecto.Migration

  def change do
    create table(:player_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :token, :binary, null: false
      add :player_id, references(:players, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:player_tokens, [:player_id])
  end
end
