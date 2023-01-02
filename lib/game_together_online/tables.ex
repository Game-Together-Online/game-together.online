defmodule GameTogetherOnline.Tables do
  @moduledoc """
  The Tables context.
  """

  alias GameTogetherOnline.Repo
  alias GameTogetherOnline.Tables.Table
  alias GameTogetherOnline.Tables.Presence
  alias GameTogetherOnline.Tables.Updates
  alias GameTogetherOnline.GameStrategy

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
      |> Repo.preload(
        players_present: [],
        game_type: [],
        chat: [
          presence_events: :player,
          chat_messages: :player,
          nickname_change_chat_events: :nickname_change_event
        ]
      )
      |> load_game_specific_data()

  def create_table(game_type, options) do
    table_strategy = GameStrategy.for_game_type(game_type)
    table_strategy.create_table(options)
  end

  def broadcast(id) when is_binary(id),
    do:
      id
      |> get_table!()
      |> Updates.broadcast()

  def broadcast(table_ids) when is_list(table_ids) do
    Table
    |> where([table], table.id in ^table_ids)
    |> Repo.all()
    |> Repo.preload(
      players_present: [],
      game_type: [],
      chat: [
        presence_events: :player,
        chat_messages: :player,
        nickname_change_chat_events: :nickname_change_event
      ]
    )
    |> load_all_game_specific_data()
    |> Enum.each(&Updates.broadcast/1)
  end

  defp load_all_game_specific_data(tables) do
    tables
    |> Enum.map(& &1.game_type)
    |> Enum.uniq_by(& &1.slug)
    |> Enum.map(&GameStrategy.for_game_type(&1))
    |> Enum.reduce(tables, fn game_strategy, tables ->
      game_strategy.load_game_specific_data(tables)
    end)
  end

  defp load_game_specific_data(table) do
    strategy = strategy_for_table(table)
    strategy.load_game_specific_data(table)
  end

  defp strategy_for_table(table), do: GameStrategy.for_game_type(table.game_type)
end
