defmodule GameTogetherOnline.TablesTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Tables
  alias GameTogetherOnline.Administration

  import GameTogetherOnline.GameTypesFixtures

  test "create_table/2 creates spades tables" do
    game_type = game_type_fixture(%{slug: "spades"})
    {:ok, table} = Tables.create_table(game_type, %{})
    [created_table] = Administration.Tables.list_tables()

    assert table.id == created_table.id
    assert created_table.status == "game-pending"
    assert created_table.game_type_id == game_type.id
  end
end
