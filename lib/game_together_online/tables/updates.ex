defmodule GameTogetherOnline.Tables.Updates do
  @topic_prefix "table_updates"
  @pubsub GameTogetherOnline.PubSub

  alias GameTogetherOnline.Tables.Table
  alias Phoenix.PubSub

  def subscribe(), do: PubSub.subscribe(@pubsub, table_topic())

  def subscribe(id), do: PubSub.subscribe(@pubsub, table_topic(id))

  def broadcast(%Table{id: id} = table) do
    PubSub.broadcast(@pubsub, table_topic(), table)
    PubSub.broadcast(@pubsub, table_topic(id), table)
  end

  defp table_topic(id), do: "#{@topic_prefix}:#{id}"
  defp table_topic(), do: "#{@topic_prefix}:all"
end
