defmodule GameTogetherOnline.Repo.Migrations.AddUserIdToPlayers do
  use Ecto.Migration

  def change do
    alter table("players") do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
    end

    create unique_index(:players, [:user_id])
  end
end
