defmodule GameTogetherOnline.Administration.ChatMessagesTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.ChatMessages

  describe "chat_messages" do
    alias GameTogetherOnline.Administration.ChatMessages.ChatMessage

    import GameTogetherOnline.Administration.ChatMessagesFixtures
    import GameTogetherOnline.Administration.PlayersFixtures
    import GameTogetherOnline.Administration.ChatsFixtures

    @invalid_attrs %{content: nil}

    test "list_chat_messages/0 returns all chat_messages" do
      chat_message = chat_message_fixture()
      assert ChatMessages.list_chat_messages() == [chat_message]
    end

    test "get_chat_message!/1 returns the chat_message with given id" do
      chat_message = chat_message_fixture()
      assert ChatMessages.get_chat_message!(chat_message.id) == chat_message
    end

    test "create_chat_message/1 with valid data creates a chat_message" do
      player = player_fixture()
      chat = chat_fixture()
      valid_attrs = %{content: "some content", chat_id: chat.id, player_id: player.id}

      assert {:ok, %ChatMessage{} = chat_message} = ChatMessages.create_chat_message(valid_attrs)
      assert chat_message.content == "some content"
    end

    test "create_chat_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ChatMessages.create_chat_message(@invalid_attrs)
    end

    test "update_chat_message/2 with valid data updates the chat_message" do
      chat_message = chat_message_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %ChatMessage{} = chat_message} =
               ChatMessages.update_chat_message(chat_message, update_attrs)

      assert chat_message.content == "some updated content"
    end

    test "update_chat_message/2 with invalid data returns error changeset" do
      chat_message = chat_message_fixture()

      assert {:error, %Ecto.Changeset{}} =
               ChatMessages.update_chat_message(chat_message, @invalid_attrs)

      assert chat_message == ChatMessages.get_chat_message!(chat_message.id)
    end

    test "delete_chat_message/1 deletes the chat_message" do
      chat_message = chat_message_fixture()
      assert {:ok, %ChatMessage{}} = ChatMessages.delete_chat_message(chat_message)
      assert_raise Ecto.NoResultsError, fn -> ChatMessages.get_chat_message!(chat_message.id) end
    end

    test "change_chat_message/1 returns a chat_message changeset" do
      chat_message = chat_message_fixture()
      assert %Ecto.Changeset{} = ChatMessages.change_chat_message(chat_message)
    end
  end
end
