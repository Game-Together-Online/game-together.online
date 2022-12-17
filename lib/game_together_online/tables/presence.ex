defmodule GameTogetherOnline.Tables.Presence do
  use Phoenix.Presence,
    otp_app: :game_together_online,
    pubsub_server: GameTogetherOnline.PubSub

  alias Phoenix.PubSub

  @topic "table_presence"
  @key "all_table_presences"

  def track(table, player),
    do: track(self(), @topic, @key, %{table_id: table.id, player_id: player.id})

  def untrack(), do: untrack(self(), @topic, @key)

  def subscribe(), do: PubSub.subscribe(GameTogetherOnline.PubSub, @topic)
end
