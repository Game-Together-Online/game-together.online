defmodule GameTogetherOnline.Repo.Migrations.CreateNicknameChangeEvents do
  use Ecto.Migration

  def change do
    create table(:nickname_change_events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :original_nickname, :string
      add :new_nickname, :string
      add :player_id, references(:players, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:nickname_change_events, [:player_id])
  end
end
