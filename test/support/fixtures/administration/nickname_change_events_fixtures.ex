defmodule GameTogetherOnline.Administration.NicknameChangeEventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameTogetherOnline.Administration.NicknameChangeEvents` context.
  """

  alias GameTogetherOnline.Administration.PlayersFixtures

  @doc """
  Generate a nickname_change_event.
  """
  def nickname_change_event_fixture(attrs \\ %{}) do
    player = PlayersFixtures.player_fixture()

    {:ok, nickname_change_event} =
      attrs
      |> Enum.into(%{
        player_id: player.id,
        new_nickname: "some new_nickname",
        original_nickname: "some original_nickname"
      })
      |> GameTogetherOnline.Administration.NicknameChangeEvents.create_nickname_change_event()

    nickname_change_event
  end
end
