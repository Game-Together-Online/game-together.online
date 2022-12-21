defmodule GameTogetherOnline.SpyfallTest do
  use GameTogetherOnline.DataCase

  import GameTogetherOnline.GameTypesFixtures

  alias GameTogetherOnline.Spyfall
  alias GameTogetherOnline.Administration.Tables
  alias GameTogetherOnline.Administration.Chats

  test "create_table/1 creates a spyfall table" do
    game_type = game_type_fixture(%{slug: "spyfall"})
    {:ok, table} = Spyfall.create_table()
    [created_table] = Tables.list_tables()

    assert table.id == created_table.id
    assert created_table.status == "game-pending"
    assert created_table.game_type_id == game_type.id

    [chat] = Chats.list_chats()
    assert chat.table_id == table.id
  end
end
