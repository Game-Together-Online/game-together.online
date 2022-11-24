defmodule GameTogetherOnline.Players.PlayerTest do
  use GameTogetherOnline.DataCase, null: false

  alias GameTogetherOnline.Players.Player

  test "is valid with valid parameters" do
    player = Player.changeset(%Player{}, %{nickname: "Some Nickname"})
    assert player.valid?
  end

  test "is invalid without a nickname" do
    player = Player.changeset(%Player{}, %{})
    refute player.valid?
  end

  describe "generate_default_nickname/0" do
    test "generates a nickname" do
      assert 15 ==
               Player.generate_default_nickname()
               |> String.length()
    end
  end
end
