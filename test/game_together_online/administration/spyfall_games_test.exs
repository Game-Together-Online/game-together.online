defmodule GameTogetherOnline.Administration.SpyfallGamesTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.SpyfallGames
  alias GameTogetherOnline.Tables
  alias GameTogetherOnline.Administration.GameTypesFixtures

  setup :create_table

  describe "spyfall_games" do
    alias GameTogetherOnline.Administration.SpyfallGames.SpyfallGame

    import GameTogetherOnline.Administration.SpyfallGamesFixtures

    @invalid_attrs %{table_id: nil}

    test "list_spyfall_games/0 returns all spyfall_games", %{table: table} do
      spyfall_game = spyfall_game_fixture(%{table_id: table.id})
      assert SpyfallGames.list_spyfall_games() == [spyfall_game]
    end

    test "get_spyfall_game!/1 returns the spyfall_game with given id", %{table: table} do
      spyfall_game = spyfall_game_fixture(%{table_id: table.id})
      assert SpyfallGames.get_spyfall_game!(spyfall_game.id) == spyfall_game
    end

    test "create_spyfall_game/1 with valid data creates a spyfall_game", %{table: table} do
      valid_attrs = %{table_id: table.id}

      assert {:ok, %SpyfallGame{} = spyfall_game} = SpyfallGames.create_spyfall_game(valid_attrs)
      assert spyfall_game.table_id == table.id
    end

    test "create_spyfall_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SpyfallGames.create_spyfall_game(@invalid_attrs)
    end

    test "update_spyfall_game/2 with valid data updates the spyfall_game", %{table: table} do
      spyfall_game = spyfall_game_fixture(%{table_id: table.id})
      update_attrs = %{}

      assert {:ok, %SpyfallGame{} = spyfall_game} =
               SpyfallGames.update_spyfall_game(spyfall_game, update_attrs)

      assert spyfall_game.table_id == table.id
    end

    test "update_spyfall_game/2 with invalid data returns error changeset", %{table: table} do
      spyfall_game = spyfall_game_fixture(%{table_id: table.id})

      assert {:error, %Ecto.Changeset{}} =
               SpyfallGames.update_spyfall_game(spyfall_game, @invalid_attrs)

      assert spyfall_game == SpyfallGames.get_spyfall_game!(spyfall_game.id)
    end

    test "delete_spyfall_game/1 deletes the spyfall_game", %{table: table} do
      spyfall_game = spyfall_game_fixture(%{table_id: table.id})
      assert {:ok, %SpyfallGame{}} = SpyfallGames.delete_spyfall_game(spyfall_game)
      assert_raise Ecto.NoResultsError, fn -> SpyfallGames.get_spyfall_game!(spyfall_game.id) end
    end

    test "change_spyfall_game/1 returns a spyfall_game changeset", %{table: table} do
      spyfall_game = spyfall_game_fixture(%{table_id: table.id})
      assert %Ecto.Changeset{} = SpyfallGames.change_spyfall_game(spyfall_game)
    end
  end

  def create_table(_) do
    game_type = GameTypesFixtures.game_type_fixture()
    {:ok, table} = Tables.create_table(game_type, %{})
    %{table: table}
  end
end
