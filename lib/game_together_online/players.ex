defmodule GameTogetherOnline.Players do
  alias GameTogetherOnline.Repo
  alias Ecto.Multi
  alias GameTogetherOnline.PlayerToken
  alias GameTogetherOnline.Players.Player
  alias GameTogetherOnline.NicknameChangeEvents.NicknameChangeEvent

  def create_player(attrs) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  def update_player(player, attrs) do
    Multi.new()
    |> Multi.update(:player, Player.changeset(player, attrs))
    |> maybe_insert_nickname_change_event(player, attrs)
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
