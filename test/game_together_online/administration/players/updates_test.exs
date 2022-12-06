defmodule GameTogetherOnline.Administration.Players.UpdatesTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.Players.Updates

  import GameTogetherOnline.Administration.PlayersFixtures

  test "subscribe/0 subscribes to all player updates" do
    player = player_fixture()
    Updates.subscribe()
    Updates.broadcast({:ok, player})

    assert_receive ^player
  end

  test "subscribe/1 subscribes to updates for the given player" do
    player = player_fixture()
    other_player = player_fixture()

    Updates.subscribe(player.id)
    Updates.broadcast({:ok, player})
    Updates.broadcast({:ok, other_player})

    assert_receive ^player
    refute_receive ^other_player
  end
end
