defmodule GameTogetherOnline.Tables do
  @moduledoc """
  The Tables context.
  """

  alias GameTogetherOnline.Repo
  alias GameTogetherOnline.Tables.Table
  alias GameTogetherOnline.Tables.Presence
  alias GameTogetherOnline.Tables.Updates

  defdelegate subscribe(), to: Updates
  defdelegate subscribe(table), to: Updates

  defdelegate track_presence(table, player), to: Presence, as: :track
  defdelegate untrack_presence(table, player), to: Presence, as: :untrack

  def get_table!(id),
    do:
      Table
      |> Repo.get!(id)
      |> Repo.preload(:game_type)
      |> Repo.preload(:players_present)
      |> Repo.preload(chat: [presence_events: :player, chat_messages: :player])

  def create_table(game_type, options) do
    table_strategy = strategy_for_table(game_type)
    table_strategy.create_table(options)
  end

  def broadcast(id),
    do:
      id
      |> get_table!()
      |> Updates.broadcast()

  defp strategy_for_table(%{slug: "spades"}), do: GameTogetherOnline.Spades
  defp strategy_for_table(%{slug: "spyfall"}), do: GameTogetherOnline.Spyfall
  defp strategy_for_table(%{slug: "chess"}), do: GameTogetherOnline.Chess
end
