defmodule GameTogetherOnline.Tables.PresenceServer do
  use GenServer
  import Ecto.Query

  alias GameTogetherOnline.Repo
  alias GameTogetherOnline.Tables.Presence
  alias GameTogetherOnline.Tables.Table
  alias GameTogetherOnline.Tables.Updates
  alias GameTogetherOnline.Tables.TablePresence

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Presence.subscribe()
    {:ok, nil}
  end

  @impl true
  def handle_info(%{payload: payload}, state) do
    insert_joins(payload.joins)
    delete_joins(payload.leaves)

    broadcast_table_updates(payload)
    {:noreply, state}
  end

  defp broadcast_table_updates(%{joins: joins, leaves: leaves}) do
    join_metas = extract_metas(joins)
    leaves_metas = extract_metas(leaves)

    (join_metas ++ leaves_metas)
    |> Enum.map(& &1.table_id)
    |> Enum.uniq()
    |> load_tables()
    |> Enum.each(&broadcast_table_update/1)
  end

  defp load_tables(table_ids) do
    Table
    |> where([t], t.id in ^table_ids)
    |> preload(:players_present)
    |> preload(:game_type)
    |> preload(chat: [chat_messages: :player])
    |> Repo.all()
  end

  defp broadcast_table_update(table), do: Updates.broadcast(table)

  defp insert_joins(joins) do
    joins
    |> extract_metas()
    |> add_players_to_table()
  end

  defp delete_joins(leaves) do
    leaves
    |> extract_metas()
    |> remove_players_from_table()
  end

  defp extract_metas(event),
    do:
      event
      |> Map.get("all_table_presences", %{})
      |> Map.get(:metas, [])

  defp add_players_to_table(players_and_tables) do
    now =
      DateTime.utc_now()
      |> DateTime.truncate(:second)

    to_insert =
      Enum.map(
        players_and_tables,
        &%{player_id: &1.player_id, table_id: &1.table_id, inserted_at: now, updated_at: now}
      )

    Repo.insert_all(TablePresence, to_insert)
  end

  defp remove_players_from_table([]), do: nil

  defp remove_players_from_table(players_and_tables) do
    players_and_tables
    |> Enum.reduce(TablePresence, fn %{table_id: table_id, player_id: player_id}, query ->
      query
      |> or_where(
        [tp],
        tp.player_id == ^player_id and tp.table_id == ^table_id
      )
    end)
    |> Repo.delete_all()
  end
end
