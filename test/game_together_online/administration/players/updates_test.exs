defmodule GameTogetherOnline.Administration.Players.UpdatesTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.Players.Updates

  import GameTogetherOnline.Administration.PlayersFixtures

  test "subscribe/0 subscribes to all player updates" do
    player = player_fixture()
    Updates.subscribe()
    Updates.broadcast({:ok, player})

    expected_player = Map.put(player, :user, nil)
    assert_receive ^expected_player
  end

  test "subscribe/1 subscribes to updates for the given player" do
    player = player_fixture()
    other_player = player_fixture()

    Updates.subscribe(player.id)
    Updates.broadcast({:ok, player})
    Updates.broadcast({:ok, other_player})

    expected_player = Map.put(player, :user, nil)
    assert_receive ^expected_player
    refute_receive ^other_player
  end

  test "unsubscribe/0 unsubscribes from all player updates" do
    player = player_fixture()
    Updates.subscribe()
    Updates.unsubscribe()
    Updates.broadcast({:ok, player})

    refute_receive _msg
  end

  test "unsubscribe/1 unsubscribes from updates for the given player" do
    player = player_fixture()

    Updates.subscribe(player.id)
    Updates.unsubscribe(player.id)
    Updates.broadcast({:ok, player})

    refute_receive _msg
  end
end
