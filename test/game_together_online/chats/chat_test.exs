defmodule GameTogetherOnline.Chats.ChatTest do
  use GameTogetherOnline.DataCase

  import GameTogetherOnline.Administration.TablesFixtures

  alias GameTogetherOnline.Chats.Chat
  alias Ecto.UUID
  alias GameTogetherOnline.Repo

  setup :build_valid_attrs

  test "is invalid without a table_id", %{valid_attrs: valid_attrs} do
    refute Chat.changeset(%Chat{}, Map.drop(valid_attrs, [:table_id])).valid?
  end

  test "is invalid with an invalid table_id", %{valid_attrs: valid_attrs} do
    assert {:error, _changeset} =
             %Chat{}
             |> Chat.changeset(Map.put(valid_attrs, :table_id, UUID.generate()))
             |> Repo.insert()
  end

  test "is valid with valid attributes", %{valid_attrs: valid_attrs} do
    assert {:ok, _chat} =
             %Chat{}
             |> Chat.changeset(valid_attrs)
             |> Repo.insert()
  end

  def build_valid_attrs(_context) do
    table = table_fixture()
    {:ok, valid_attrs: %{table_id: table.id}}
  end
end
