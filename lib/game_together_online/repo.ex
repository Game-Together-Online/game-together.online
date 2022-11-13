defmodule GameTogetherOnline.Repo do
  use Ecto.Repo,
    otp_app: :game_together_online,
    adapter: Ecto.Adapters.Postgres
end
