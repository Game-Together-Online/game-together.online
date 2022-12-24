defmodule GameTogetherOnline.ChatMessagesTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.ChatMessages

  describe "chat_messages" do
    alias GameTogetherOnline.ChatMessages.ChatMessage

    import GameTogetherOnline.Administration.ChatMessagesFixtures
    import GameTogetherOnline.Administration.PlayersFixtures
    import GameTogetherOnline.Administration.ChatsFixtures

    @invalid_attrs %{content: nil}

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

    test "change_chat_message/1 returns a chat_message changeset" do
      assert %Ecto.Changeset{} = ChatMessages.change_chat_message(%ChatMessage{})
    end
  end
end
