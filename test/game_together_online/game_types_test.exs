defmodule GameTogetherOnline.GameTypesTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.GameTypes

  describe "game_types" do
    import GameTogetherOnline.GameTypesFixtures

    test "list_game_types/0 returns all game_types" do
      game_type = game_type_fixture()
      [loaded_game_type] = GameTypes.list_game_types()

      assert loaded_game_type.id == game_type.id
      assert loaded_game_type.name == game_type.name
      assert loaded_game_type.description == game_type.description
      assert loaded_game_type.slug == game_type.slug
      assert loaded_game_type.inserted_at == game_type.inserted_at
      assert loaded_game_type.updated_at == game_type.updated_at
    end
  end
end
