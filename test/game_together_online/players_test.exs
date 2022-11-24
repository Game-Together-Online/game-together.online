defmodule GameTogetherOnline.PlayersTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Players
  alias GameTogetherOnline.Players.Player
  alias GameTogetherOnline.Administration.PlayersFixtures

  test "create_player/1 with valid data creates a role" do
    valid_attrs = %{nickname: "some nickname"}

    assert {:ok, %Player{} = player} = Players.create_player(valid_attrs)
    assert player.nickname == "some nickname"
  end

  test "create_player/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Players.create_player(%{})
  end

  describe "get_player_by_session_token/1" do
    setup do
      player = PlayersFixtures.player_fixture()
      token = Players.generate_player_session_token(player)
      %{player: player, token: token}
    end

    test "returns player by token", %{player: player, token: token} do
      assert session_player = Players.get_player_by_session_token(token)
      assert session_player.id == player.id
    end

    test "does not return player for invalid token" do
      refute Players.get_player_by_session_token("bad token")
    end
  end
end
