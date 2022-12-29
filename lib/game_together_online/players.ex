defmodule GameTogetherOnline.Players do
  alias GameTogetherOnline.Repo
  alias Ecto.Multi
  alias GameTogetherOnline.PlayerToken
  alias GameTogetherOnline.Players.Player
  alias GameTogetherOnline.Tables
  alias GameTogetherOnline.NicknameChangeEvents.NicknameChangeEvent
  alias GameTogetherOnline.NicknameChangeEvents.NicknameChangeChatEvent

  import Ecto.Query

  def create_player(attrs) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  def update_player(player, attrs) do
    Multi.new()
    |> Multi.update(:player, Player.changeset(player, attrs))
    |> maybe_insert_nickname_change_event(player, attrs)
    |> maybe_add_nickname_changes_to_chats()
    |> Repo.transaction()
    |> extract_the_player_update_results()
  end

  defp extract_the_player_update_results({:error, :player, changeset, %{}}),
    do: {:error, changeset}

  defp extract_the_player_update_results({:ok, %{player: player}}), do: {:ok, player}

  defp maybe_insert_nickname_change_event(multi, %{nickname: nickname}, %{"nickname" => nickname}),
    do: multi

  defp maybe_insert_nickname_change_event(multi, player, attrs) do
    Multi.insert(
      multi,
      :nickname_change_event,
      NicknameChangeEvent.changeset(%NicknameChangeEvent{}, %{
        player_id: player.id,
        original_nickname: player.nickname,
        new_nickname: attrs["nickname"]
      })
    )
  end

  defp maybe_add_nickname_changes_to_chats(multi) do
    Multi.run(multi, :nickname_change_chat_events, &maybe_add_nickname_changes_to_chats/2)
  end

  defp maybe_add_nickname_changes_to_chats(repo, %{
         player: player,
         nickname_change_event: nickname_change_event
       }) do
    now =
      DateTime.utc_now()
      |> DateTime.truncate(:second)

    to_insert =
      player
      |> Tables.with_player()
      |> preload(:chat)
      |> repo.all()
      |> Enum.map(
        &%{
          chat_id: &1.chat.id,
          nickname_change_event_id: nickname_change_event.id,
          inserted_at: now,
          updated_at: now
        }
      )

    {_number_inserted, nickname_change_chat_events} =
      Repo.insert_all(NicknameChangeChatEvent, to_insert, returning: true)

    {:ok, nickname_change_chat_events}
  end

  defp maybe_add_nickname_changes_to_chats(_repo, _changes_so_far), do: {:ok, nil}

  def change_player(%Player{} = player, attrs \\ %{}) do
    Player.changeset(player, attrs)
  end

  def get_player_by_session_token(token) do
    {:ok, query} = PlayerToken.verify_session_token_query(token)
    Repo.one(query)
  end

  def generate_player_session_token(player) do
    {token, player_token} = PlayerToken.build_session_token(player)
    Repo.insert!(player_token)
    token
  end
end
