defmodule GameTogetherOnline.Administration.SpyfallParticipantsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameTogetherOnline.Administration.SpyfallParticipants` context.
  """

  alias GameTogetherOnline.Administration.PlayersFixtures
  alias GameTogetherOnline.Administration.SpyfallGamesFixtures
  alias GameTogetherOnline.Administration.TablesFixtures

  @doc """
  Generate a spyfall_participant.
  """
  def spyfall_participant_fixture(attrs \\ %{}) do
    table = TablesFixtures.table_fixture()
    spyfall_game = SpyfallGamesFixtures.spyfall_game_fixture(%{table_id: table.id})
    player = PlayersFixtures.player_fixture()

    {:ok, spyfall_participant} =
      attrs
      |> Enum.into(%{
        ready_to_start: true,
        player_id: player.id,
        spyfall_game_id: spyfall_game.id
      })
      |> GameTogetherOnline.Administration.SpyfallParticipants.create_spyfall_participant()

    spyfall_participant
  end
end
