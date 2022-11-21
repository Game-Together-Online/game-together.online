defmodule GameTogetherOnline.SpadesTest do
  use GameTogetherOnline.DataCase

  import GameTogetherOnline.GameTypesFixtures

  alias GameTogetherOnline.Spades
  alias GameTogetherOnline.Administration.Tables

  test "create_table/1 creates a spades table" do
    game_type = game_type_fixture(%{slug: "spades"})
    {:ok, table} = Spades.create_table()
    [created_table] = Tables.list_tables()

    assert table.id == created_table.id
    assert created_table.status == "game-pending"
    assert created_table.game_type_id == game_type.id
  end
end
