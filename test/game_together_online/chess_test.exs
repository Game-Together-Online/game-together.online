defmodule GameTogetherOnline.ChessTest do
  use GameTogetherOnline.DataCase

  import GameTogetherOnline.GameTypesFixtures

  alias GameTogetherOnline.Chess
  alias GameTogetherOnline.Administration.Tables
  alias GameTogetherOnline.Administration.Chats

  test "create_table/1 creates a chess table" do
    game_type = game_type_fixture(%{slug: "chess"})
    {:ok, table} = Chess.create_table(%{})
    [created_table] = Tables.list_tables()

    assert table.id == created_table.id
    assert created_table.status == "game-pending"
    assert created_table.game_type_id == game_type.id

    [chat] = Chats.list_chats()
    assert chat.table_id == table.id
  end
end
