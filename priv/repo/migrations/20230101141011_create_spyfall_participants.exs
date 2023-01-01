defmodule GameTogetherOnline.Repo.Migrations.CreateSpyfallParticipants do
  use Ecto.Migration

  def change do
    create table(:spyfall_participants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :ready_to_start, :boolean, default: false, null: false
      add :player_id, references(:players, on_delete: :nothing, type: :binary_id)
      add :spyfall_game_id, references(:spyfall_games, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:spyfall_participants, [:player_id])
    create index(:spyfall_participants, [:spyfall_game_id])
    create unique_index(:spyfall_participants, [:spyfall_game_id, :player_id])
  end
end
