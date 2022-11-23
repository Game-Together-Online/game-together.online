defmodule GameTogetherOnline.TablesTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.TablesFixtures
  alias GameTogetherOnline.Tables
  alias GameTogetherOnline.Administration
  alias Ecto.UUID

  import GameTogetherOnline.GameTypesFixtures

  test "get_table!/1 returns the table with given id" do
    table = TablesFixtures.table_fixture()
    loaded_table = Tables.get_table!(table.id)

    assert equal?(table, loaded_table)
  end

  test "get_table!/1 raises an error when there is not a matching table" do
    assert_raise Ecto.NoResultsError, fn -> Tables.get_table!(UUID.generate()) end
  end

  test "create_table/2 creates spades tables" do
    game_type = game_type_fixture(%{slug: "spades"})
    {:ok, table} = Tables.create_table(game_type, %{})
    [created_table] = Administration.Tables.list_tables()

    assert table.id == created_table.id
    assert created_table.status == "game-pending"
    assert created_table.game_type_id == game_type.id
  end

  test "create_table/2 creates spyfall tables" do
    game_type = game_type_fixture(%{slug: "spyfall"})
    {:ok, table} = Tables.create_table(game_type, %{})
    [created_table] = Administration.Tables.list_tables()

    assert table.id == created_table.id
    assert created_table.status == "game-pending"
    assert created_table.game_type_id == game_type.id
  end

  defp equal?(first_table, second_table) do
    first_table.id == second_table.id &&
      first_table.status == second_table.status &&
      first_table.game_type_id == second_table.game_type_id
  end
end
