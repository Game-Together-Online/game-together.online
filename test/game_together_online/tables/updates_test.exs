defmodule GameTogetherOnline.Tables.UpdatesTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Tables.Updates
  alias GameTogetherOnline.Tables

  alias GameTogetherOnline.GameTypesFixtures

  setup :create_table

  test "broadcast/1 broadcasts to the table's channel", %{table: table} do
    Updates.subscribe(table.id)
    Updates.broadcast(table)
    assert_receive ^table
  end

  test "broadcast/1 broadcasts to the table channel", %{table: table} do
    Updates.subscribe()
    Updates.broadcast(table)
    assert_receive ^table
  end

  def create_table(_) do
    game_type = GameTypesFixtures.game_type_fixture()
    {:ok, table} = Tables.create_table(game_type, %{})
    %{table: table}
  end
end
