defmodule GameTogetherOnline.Administration.ChatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameTogetherOnline.Administration.Chats` context.
  """

  import GameTogetherOnline.Administration.TablesFixtures

  @doc """
  Generate a chat.
  """
  def chat_fixture(attrs \\ %{}) do
    table = table_fixture()

    {:ok, chat} =
      attrs
      |> Enum.into(%{
        table_id: table.id
      })
      |> GameTogetherOnline.Administration.Chats.create_chat()

    chat
  end
end
