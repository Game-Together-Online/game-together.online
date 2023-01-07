defmodule GameTogetherOnline.SpyfallParticipantsTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.SpyfallParticipants
  alias GameTogetherOnline.Repo

  describe "spyfall_participants" do
    alias GameTogetherOnline.SpyfallParticipants.SpyfallParticipant

    alias GameTogetherOnline.Administration.SpyfallGamesFixtures
    alias GameTogetherOnline.Administration.PlayersFixtures
    alias GameTogetherOnline.Administration.TablesFixtures

    @invalid_attrs %{ready_to_start: nil}

    test "toggle_readiness/1 toggles the readiness for the participant" do
      player = PlayersFixtures.player_fixture()
      table = TablesFixtures.table_fixture()
      spyfall_game = SpyfallGamesFixtures.spyfall_game_fixture(%{table_id: table.id})

      valid_attrs = %{
        ready_to_start: true,
        player_id: player.id,
        spyfall_game_id: spyfall_game.id
      }

      assert {:ok, %SpyfallParticipant{} = spyfall_participant} =
               SpyfallParticipants.create_spyfall_participant(valid_attrs)

      {:ok, spyfall_participant} = SpyfallParticipants.toggle_readiness(spyfall_participant)
      refute spyfall_participant.ready_to_start

      {:ok, spyfall_participant} = SpyfallParticipants.toggle_readiness(spyfall_participant)
      assert spyfall_participant.ready_to_start
    end

    test "delete_spyfall_participant_by_game_and_player/2 deletes any matching participants" do
      player = PlayersFixtures.player_fixture()
      table = TablesFixtures.table_fixture()
      spyfall_game = SpyfallGamesFixtures.spyfall_game_fixture(%{table_id: table.id})

      valid_attrs = %{
        ready_to_start: true,
        player_id: player.id,
        spyfall_game_id: spyfall_game.id
      }

      {:ok, %SpyfallParticipant{}} = SpyfallParticipants.create_spyfall_participant(valid_attrs)

      SpyfallParticipants.delete_spyfall_participant_by_game_and_player(
        spyfall_game.id,
        player.id
      )

      assert [] == Repo.all(SpyfallParticipant)
    end

    test "create_spyfall_participant/1 with valid data creates a spyfall_participant" do
      player = PlayersFixtures.player_fixture()
      table = TablesFixtures.table_fixture()
      spyfall_game = SpyfallGamesFixtures.spyfall_game_fixture(%{table_id: table.id})

      valid_attrs = %{
        ready_to_start: true,
        player_id: player.id,
        spyfall_game_id: spyfall_game.id
      }

      assert {:ok, %SpyfallParticipant{} = spyfall_participant} =
               SpyfallParticipants.create_spyfall_participant(valid_attrs)

      assert spyfall_participant.ready_to_start == true
    end

    test "create_spyfall_participant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               SpyfallParticipants.create_spyfall_participant(@invalid_attrs)
    end
  end
end
