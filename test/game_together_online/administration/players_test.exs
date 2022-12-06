defmodule GameTogetherOnline.Administration.PlayersTest do
  use GameTogetherOnline.DataCase

  import GameTogetherOnline.AccountsFixtures
  alias GameTogetherOnline.Administration.Players

  describe "players" do
    alias GameTogetherOnline.Administration.Players.Player

    import GameTogetherOnline.Administration.PlayersFixtures

    @invalid_attrs %{nickname: nil}

    test "list_players_without_users_by_nickname/1 returns all with a similar nickname" do
      player_fixture(%{nickname: "some-nickname"})
      player = player_fixture(%{nickname: "oThErNick"})

      assert [player] == Players.list_players_without_users_by_nickname("otherN")
    end

    test "list_players_without_users_by_nickname/1 limits the result list to 10 if no page size has been given" do
      for i <- 1..15, do: player_fixture(%{nickname: "some-nickname-#{i}"})

      assert "some-NicKnAme"
             |> Players.list_players_without_users_by_nickname()
             |> length() == 10
    end

    test "list_players_without_users_by_nickname/1 limits the result list to the given page size" do
      for i <- 1..15, do: player_fixture(%{nickname: "some-nickname-#{i}"})

      assert "some-NicKnAme"
             |> Players.list_players_without_users_by_nickname(page_size: 5)
             |> length() == 5
    end

    test "list_players_without_users_by_nickname/1 only returns players without users" do
      for i <- 1..15 do
        user = user_fixture(%{email: "user-#{i}@email.org"})
        player_fixture(%{nickname: "some-nickname-#{i}", user_id: user.id})
      end

      assert ""
             |> Players.list_players_without_users_by_nickname(page_size: 5)
             |> length() == 0
    end

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Players.list_players() == [Map.put(player, :user, nil)]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()

      assert player.id
             |> Players.get_player!()
             |> Map.put(:user, nil) == Map.put(player, :user, nil)
    end

    test "create_player/1 with valid data creates a player" do
      valid_attrs = %{nickname: "some nickname"}

      assert {:ok, %Player{} = player} = Players.create_player(valid_attrs)
      assert player.nickname == "some nickname"
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Players.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      update_attrs = %{nickname: "some updated nickname"}

      assert {:ok, %Player{} = player} = Players.update_player(player, update_attrs)
      assert player.nickname == "some updated nickname"
    end

    test "update_player/2 with valid data broadcasts the player" do
      player = player_fixture()
      update_attrs = %{nickname: "some updated nickname"}

      Players.subscribe_to_updates(player.id)

      {:ok, player} = Players.update_player(player, update_attrs)

      expected_player = Map.put(player, :user, nil)
      assert_receive ^expected_player
    end

    test "update_player/2 with valid data broadcasts the change" do
      player = player_fixture()
      update_attrs = %{nickname: "some updated nickname"}

      Players.subscribe_to_updates()

      {:ok, player} = Players.update_player(player, update_attrs)

      expected_player = Map.put(player, :user, nil)
      assert_receive ^expected_player
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Players.update_player(player, @invalid_attrs)

      assert Map.put(player, :user, nil) ==
               player.id
               |> Players.get_player!()
               |> Map.put(:user, nil)
    end

    test "update_player/2 with invalid data does not broadcast the update" do
      player = player_fixture()
      Players.subscribe_to_updates()
      Players.subscribe_to_updates(player.id)

      Players.update_player(player, @invalid_attrs)

      refute_receive _msg
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Players.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Players.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Players.change_player(player)
    end

    test "unsubscribe_from_updates/0 unsubscribes from unscoped updates" do
      player = player_fixture()
      update_attrs = %{nickname: "some updated nickname"}

      Players.subscribe_to_updates()
      Players.unsubscribe_from_updates()

      {:ok, _player} = Players.update_player(player, update_attrs)

      refute_receive _msg
    end

    test "unsubscribe_from_updates/1 unsubscribes updates for the given player" do
      player = player_fixture()
      update_attrs = %{nickname: "some updated nickname"}

      Players.subscribe_to_updates(player.id)
      Players.unsubscribe_from_updates(player.id)

      {:ok, _player} = Players.update_player(player, update_attrs)

      refute_receive _msg
    end
  end
end
