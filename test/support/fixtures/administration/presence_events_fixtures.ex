defmodule GameTogetherOnline.Administration.PresenceEventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameTogetherOnline.Administration.PresenceEvents` context.
  """

  import GameTogetherOnline.Administration.ChatsFixtures
  import GameTogetherOnline.Administration.PlayersFixtures

  @doc """
  Generate a presence_event.
  """
  def presence_event_fixture(attrs \\ %{}) do
    player = player_fixture()
    chat = chat_fixture()

    {:ok, presence_event} =
      attrs
      |> Enum.into(%{
        type: "leave",
        chat_id: chat.id,
        player_id: player.id
      })
      |> GameTogetherOnline.Administration.PresenceEvents.create_presence_event()

    presence_event
  end
end
