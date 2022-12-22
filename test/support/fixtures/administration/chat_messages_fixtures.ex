defmodule GameTogetherOnline.Administration.ChatMessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameTogetherOnline.Administration.ChatMessages` context.
  """

  alias GameTogetherOnline.Administration.PlayersFixtures
  alias GameTogetherOnline.Administration.ChatsFixtures

  @doc """
  Generate a chat_message.
  """
  def chat_message_fixture(attrs \\ %{}) do
    chat = ChatsFixtures.chat_fixture()
    player = PlayersFixtures.player_fixture()

    {:ok, chat_message} =
      attrs
      |> Enum.into(%{
        content: "some content",
        chat_id: chat.id,
        player_id: player.id
      })
      |> GameTogetherOnline.Administration.ChatMessages.create_chat_message()

    chat_message
  end
end
