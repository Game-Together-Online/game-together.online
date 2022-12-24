defmodule GameTogetherOnline.Administration.Players.Updates do
  alias Phoenix.PubSub
  alias GameTogetherOnline.Repo

  @topic_prefix "administration:player-updates"
  @pubsub GameTogetherOnline.PubSub

  def broadcast({:ok, player}) do
    player_with_user = Repo.preload(player, :user, force: true)
    PubSub.broadcast(@pubsub, topic(player.id), player_with_user)
    PubSub.broadcast(@pubsub, topic("all"), player_with_user)
    {:ok, player}
  end

  def broadcast(player), do: player

  def subscribe(), do: PubSub.subscribe(@pubsub, topic("all"))
  def subscribe(player_id), do: PubSub.subscribe(@pubsub, topic(player_id))

  def unsubscribe(), do: PubSub.unsubscribe(@pubsub, topic("all"))
  def unsubscribe(player_id), do: PubSub.unsubscribe(@pubsub, topic(player_id))

  defp topic(player_id), do: "#{@topic_prefix}:#{player_id}"
end
