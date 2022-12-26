defmodule GameTogetherOnline.PlayersTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Players
  alias GameTogetherOnline.Players.Player
  alias GameTogetherOnline.Administration.NicknameChangeEvents
  alias GameTogetherOnline.Administration.PlayersFixtures
  alias GameTogetherOnline.Administration

  test "create_player/1 with valid data creates a role" do
    valid_attrs = %{nickname: "some nickname"}

    assert {:ok, %Player{} = player} = Players.create_player(valid_attrs)
    assert player.nickname == "some nickname"
  end

  test "create_player/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Players.create_player(%{})
  end

  test "update_player/2 with valid data updates the player" do
    player = PlayersFixtures.player_fixture()
    update_attrs = %{"nickname" => "some updated nickname"}

    {:ok, updated_player} = Players.update_player(player, update_attrs)

    assert updated_player.nickname == "some updated nickname"
    assert updated_player.id == player.id
  end

  test "update_player/2 with valid data creates a nickname change event when the nickname is changed" do
    player = PlayersFixtures.player_fixture()
    update_attrs = %{"nickname" => "some updated nickname"}

    {:ok, updated_player} = Players.update_player(player, update_attrs)
    [nickname_change_event] = NicknameChangeEvents.list_nickname_change_events()

    assert nickname_change_event.player_id == player.id
    assert nickname_change_event.original_nickname == player.nickname
    assert nickname_change_event.new_nickname == updated_player.nickname
  end

  test "update_player/2 with valid data does not create a nickname change event when the nickname is not changed" do
    player = PlayersFixtures.player_fixture()
    update_attrs = %{"nickname" => player.nickname}

    Players.update_player(player, update_attrs)
    assert [] = NicknameChangeEvents.list_nickname_change_events()
  end

  test "update_player/2 with invalid data returns error changeset" do
    player = PlayersFixtures.player_fixture()
    assert {:error, %Ecto.Changeset{}} = Players.update_player(player, %{nickname: ""})
    assert Map.put(player, :user, nil) == Administration.Players.get_player!(player.id)
    assert [] = NicknameChangeEvents.list_nickname_change_events()
  end

  test "change_player/1 returns a player changeset" do
    valid_attrs = %{nickname: "some nickname"}

    assert {:ok, %Player{} = player} = Players.create_player(valid_attrs)
    assert %Ecto.Changeset{} = Players.change_player(player)
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
