defmodule GameTogetherOnline.Administration.Players.Updates do
  alias Phoenix.PubSub

  @topic_prefix "administration:player-updates"
  @pubsub GameTogetherOnline.PubSub

  def broadcast({:ok, player}) do
    PubSub.broadcast(@pubsub, topic(player.id), player)
    PubSub.broadcast(@pubsub, topic("all"), player)
    {:ok, player}
  end

  def broadcast(player), do: player

  def subscribe(), do: PubSub.subscribe(@pubsub, topic("all"))
  def subscribe(player_id), do: PubSub.subscribe(@pubsub, topic(player_id))

  defp topic(player_id), do: "#{@topic_prefix}:#{player_id}"
end
