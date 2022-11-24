defmodule GameTogetherOnline.PlayerTokenTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.PlayerToken
  alias GameTogetherOnline.Repo
  alias GameTogetherOnline.Administration.PlayersFixtures
  alias Ecto.UUID

  setup do
    {:ok, player: PlayersFixtures.player_fixture()}
  end

  test "is invalid without a token", %{player: player} do
    refute PlayerToken.changeset(%PlayerToken{}, %{player_id: player.id}).valid?
  end

  test "is invalid without a player" do
    refute PlayerToken.changeset(%PlayerToken{}, %{token: UUID.generate()}).valid?
  end

  test "is invalid with an invalid player" do
    alias GameTogetherOnline.PlayerToken

    assert {:error, _changeset} =
             %PlayerToken{}
             |> PlayerToken.changeset(%{
               token: UUID.generate(),
               player_id: UUID.generate()
             })
             |> Repo.insert()
  end

  test "is valid with an valid attributes", %{player: player} do
    assert {:ok, _player_token} =
             %PlayerToken{}
             |> PlayerToken.changeset(%{
               token: UUID.generate(),
               player_id: player.id
             })
             |> Repo.insert()
  end

  describe "build_session_token/1" do
    test "builds a session token", %{player: player} do
      {token, player_token} = PlayerToken.build_session_token(player)
      assert token == player_token.token
      assert player.id == player_token.player_id
    end
  end

  describe "verify_session_token_query/1" do
    test "returns the player when a token is found", %{player: player} do
      {token, player_token} = PlayerToken.build_session_token(player)
      Repo.insert(player_token)
      {:ok, query} = PlayerToken.verify_session_token_query(token)
      loaded_player = Repo.one(query)

      assert loaded_player.id == player.id
    end

    test "returns no results when a token is not found" do
      {:ok, query} =
        UUID.generate()
        |> PlayerToken.verify_session_token_query()

      assert nil == Repo.one(query)
    end
  end
end
