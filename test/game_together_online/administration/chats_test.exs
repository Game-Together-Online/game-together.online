defmodule GameTogetherOnline.Administration.ChatsTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.Chats

  describe "chats" do
    alias GameTogetherOnline.Administration.Chats.Chat
    alias GameTogetherOnline.Tables

    import GameTogetherOnline.Administration.ChatsFixtures
    import GameTogetherOnline.Administration.TablesFixtures
    import GameTogetherOnline.Administration.GameTypesFixtures

    @invalid_attrs %{table_id: nil}

    test "list_chats/0 returns all chats" do
      chat = chat_fixture()
      assert Chats.list_chats() == [chat]
    end

    test "get_chat!/1 returns the chat with given id" do
      chat = chat_fixture()
      assert Chats.get_chat!(chat.id) == chat
    end

    test "create_chat/1 with valid data creates a chat" do
      table = table_fixture()
      valid_attrs = %{table_id: table.id}

      assert {:ok, %Chat{} = chat} = Chats.create_chat(valid_attrs)

      assert chat.table_id == table.id
    end

    test "create_chat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chats.create_chat(@invalid_attrs)
    end

    test "update_chat/2 with valid data updates the chat" do
      game_type = game_type_fixture(%{slug: "spyfall"})
      {:ok, table} = Tables.create_table(game_type, %{})
      chat = chat_fixture()
      update_attrs = %{table_id: table.id}

      assert {:ok, %Chat{} = chat} = Chats.update_chat(chat, update_attrs)

      assert chat.table_id == table.id
    end

    test "update_chat/2 with invalid data returns error changeset" do
      chat = chat_fixture()
      assert {:error, %Ecto.Changeset{}} = Chats.update_chat(chat, @invalid_attrs)
      assert chat == Chats.get_chat!(chat.id)
    end

    test "delete_chat/1 deletes the chat" do
      chat = chat_fixture()
      assert {:ok, %Chat{}} = Chats.delete_chat(chat)
      assert_raise Ecto.NoResultsError, fn -> Chats.get_chat!(chat.id) end
    end

    test "change_chat/1 returns a chat changeset" do
      chat = chat_fixture()
      assert %Ecto.Changeset{} = Chats.change_chat(chat)
    end
  end
end
