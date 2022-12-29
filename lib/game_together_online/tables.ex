defmodule GameTogetherOnline.Tables do
  @moduledoc """
  The Tables context.
  """

  alias GameTogetherOnline.Repo
  alias GameTogetherOnline.Tables.Table
  alias GameTogetherOnline.Tables.Presence
  alias GameTogetherOnline.Tables.Updates

  import Ecto.Query

  defdelegate subscribe(), to: Updates
  defdelegate subscribe(table), to: Updates

  defdelegate track_presence(table, player), to: Presence, as: :track
  defdelegate untrack_presence(table, player), to: Presence, as: :untrack

  def with_player(%{id: player_id}) do
    from table in Table,
      join: table_presence in assoc(table, :table_presences),
      where: table_presence.player_id == ^player_id,
      select: table
  end

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

  def broadcast(id) when is_binary(id),
    do:
      id
      |> get_table!()
      |> Updates.broadcast()

  # TODO: Test this
  def broadcast(table_ids) when is_list(table_ids),
    do:
      Table
      |> where([table], table.id in ^table_ids)
      |> Repo.all()
      |> Repo.preload(:game_type)
      |> Repo.preload(:players_present)
      |> Repo.preload(chat: [presence_events: :player, chat_messages: :player])
      |> Enum.each(&Updates.broadcast/1)

  defp strategy_for_table(%{slug: "spades"}), do: GameTogetherOnline.Spades
  defp strategy_for_table(%{slug: "spyfall"}), do: GameTogetherOnline.Spyfall
  defp strategy_for_table(%{slug: "chess"}), do: GameTogetherOnline.Chess
end
