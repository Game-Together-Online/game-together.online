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
    assert {:ok, _player} =
             %PlayerToken{}
             |> PlayerToken.changeset(%{
               token: UUID.generate(),
               player_id: player.id
             })
             |> Repo.insert()
  end
end
