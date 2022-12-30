defmodule GameTogetherOnline.Tables.PresenceServer do
  use GenServer
  import Ecto.Query

  alias GameTogetherOnline.Repo
  alias GameTogetherOnline.Tables.Presence
  alias GameTogetherOnline.Tables.Table
  alias GameTogetherOnline.Chats.Chat
  alias GameTogetherOnline.Tables.Updates
  alias GameTogetherOnline.Tables.TablePresence
  alias GameTogetherOnline.PresenceEvents.PresenceEvent

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

    create_presence_events(payload)

    broadcast_table_updates(payload)
    {:noreply, state}
  end

  defp create_presence_events(payload) do
    now =
      DateTime.utc_now()
      |> DateTime.truncate(:second)

    to_insert =
      payload
      |> presence_events()
      |> Enum.map(&Map.put(&1, :inserted_at, now))
      |> Enum.map(&Map.put(&1, :updated_at, now))

    Repo.insert_all(PresenceEvent, to_insert)
  end

  defp presence_events(payload) do
    join_metas = extract_metas(payload.joins)
    leaves_metas = extract_metas(payload.leaves)

    chats =
      (join_metas ++ leaves_metas)
      |> Enum.map(& &1.table_id)
      |> Enum.uniq()
      |> load_chats()

    join_events(payload.joins, chats) ++ leave_events(payload.leaves, chats)
  end

  defp join_events(joins, chats) do
    joins
    |> extract_metas()
    |> Enum.map(
      &%{
        player_id: &1.player_id,
        chat_id: Enum.find(chats, fn chat -> chat.table_id == &1.table_id end).id,
        type: "join"
      }
    )
  end

  defp leave_events(leaves, chats) do
    leaves
    |> extract_metas()
    |> Enum.map(
      &%{
        player_id: &1.player_id,
        chat_id: Enum.find(chats, fn chat -> chat.table_id == &1.table_id end).id,
        type: "leave"
      }
    )
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

  defp load_chats(table_ids) do
    Chat
    |> where([c], c.table_id in ^table_ids)
    |> Repo.all()
  end

  defp load_tables(table_ids) do
    Table
    |> where([t], t.id in ^table_ids)
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
