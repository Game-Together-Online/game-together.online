defmodule GameTogetherOnline.Administration.TablesTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.GameTypesFixtures
  alias GameTogetherOnline.Administration.Tables

  describe "tables" do
    alias GameTogetherOnline.Administration.Tables.Table

    import GameTogetherOnline.Administration.TablesFixtures

    @invalid_attrs %{status: nil}

    test "list_tables/0 returns all tables" do
      table = table_fixture()

      assert Tables.list_tables()
             |> Enum.map(&Map.put(&1, :game_type, table.game_type)) == [
               table
             ]
    end

    test "get_table!/1 returns the table with given id" do
      table = table_fixture()

      assert table ==
               table.id
               |> Tables.get_table!()
               |> Map.put(:game_type, table.game_type)
    end

    test "create_table/1 with valid data creates a table" do
      game_type = GameTypesFixtures.game_type_fixture()
      valid_attrs = %{status: "game-in-progress", game_type_id: game_type.id}

      assert {:ok, %Table{} = table} = Tables.create_table(valid_attrs)
      assert table.status == "game-in-progress"
    end

    test "create_table/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tables.create_table(@invalid_attrs)
    end

    test "update_table/2 with valid data updates the table" do
      table = table_fixture()
      update_attrs = %{status: "game-in-progress"}

      assert {:ok, %Table{} = table} = Tables.update_table(table, update_attrs)
      assert table.status == "game-in-progress"
    end

    test "update_table/2 with invalid data returns error changeset" do
      table = table_fixture()
      assert {:error, %Ecto.Changeset{}} = Tables.update_table(table, @invalid_attrs)

      assert table.id
             |> Tables.get_table!()
             |> Map.put(:game_type, table.game_type) == table
    end

    test "delete_table/1 deletes the table" do
      table = table_fixture()
      assert {:ok, %Table{}} = Tables.delete_table(table)
      assert_raise Ecto.NoResultsError, fn -> Tables.get_table!(table.id) end
    end

    test "change_table/1 returns a table changeset" do
      table = table_fixture()
      assert %Ecto.Changeset{} = Tables.change_table(table)
    end
  end
end
