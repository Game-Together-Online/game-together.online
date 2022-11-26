defmodule GameTogetherOnline.Repo.Migrations.AddEnabledToGameTypes do
  use Ecto.Migration

  def change do
    alter table("game_types") do
      add :enabled, :boolean, default: false
    end
  end
end
