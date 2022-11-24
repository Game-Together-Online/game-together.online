defmodule GameTogetherOnline.Players do
  alias GameTogetherOnline.Repo
  alias GameTogetherOnline.PlayerToken

  alias GameTogetherOnline.Players.Player

  def create_player(attrs) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
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
