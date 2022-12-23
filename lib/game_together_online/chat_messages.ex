defmodule GameTogetherOnline.ChatMessages do
  alias GameTogetherOnline.ChatMessages.ChatMessage
  alias GameTogetherOnline.Repo

  # TODO: Test this
  def create_chat_message(attrs \\ %{}) do
    %ChatMessage{}
    |> ChatMessage.changeset(attrs)
    |> Repo.insert()
  end

  # TODO: Test this
  def change_chat_message(%ChatMessage{} = chat_message, attrs \\ %{}) do
    ChatMessage.changeset(chat_message, attrs)
  end
end
