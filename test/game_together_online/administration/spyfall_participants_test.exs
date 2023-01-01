defmodule GameTogetherOnline.Administration.SpyfallParticipantsTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.SpyfallParticipants

  describe "spyfall_participants" do
    alias GameTogetherOnline.Administration.SpyfallParticipants.SpyfallParticipant

    import GameTogetherOnline.Administration.SpyfallParticipantsFixtures
    alias GameTogetherOnline.Administration.SpyfallGamesFixtures
    alias GameTogetherOnline.Administration.PlayersFixtures
    alias GameTogetherOnline.Administration.TablesFixtures

    @invalid_attrs %{ready_to_start: nil}

    test "list_spyfall_participants/0 returns all spyfall_participants" do
      spyfall_participant = spyfall_participant_fixture()
      assert SpyfallParticipants.list_spyfall_participants() == [spyfall_participant]
    end

    test "get_spyfall_participant!/1 returns the spyfall_participant with given id" do
      spyfall_participant = spyfall_participant_fixture()

      assert SpyfallParticipants.get_spyfall_participant!(spyfall_participant.id) ==
               spyfall_participant
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

    test "update_spyfall_participant/2 with valid data updates the spyfall_participant" do
      spyfall_participant = spyfall_participant_fixture()
      update_attrs = %{ready_to_start: false}

      assert {:ok, %SpyfallParticipant{} = spyfall_participant} =
               SpyfallParticipants.update_spyfall_participant(spyfall_participant, update_attrs)

      assert spyfall_participant.ready_to_start == false
    end

    test "update_spyfall_participant/2 with invalid data returns error changeset" do
      spyfall_participant = spyfall_participant_fixture()

      assert {:error, %Ecto.Changeset{}} =
               SpyfallParticipants.update_spyfall_participant(spyfall_participant, @invalid_attrs)

      assert spyfall_participant ==
               SpyfallParticipants.get_spyfall_participant!(spyfall_participant.id)
    end

    test "delete_spyfall_participant/1 deletes the spyfall_participant" do
      spyfall_participant = spyfall_participant_fixture()

      assert {:ok, %SpyfallParticipant{}} =
               SpyfallParticipants.delete_spyfall_participant(spyfall_participant)

      assert_raise Ecto.NoResultsError, fn ->
        SpyfallParticipants.get_spyfall_participant!(spyfall_participant.id)
      end
    end

    test "change_spyfall_participant/1 returns a spyfall_participant changeset" do
      spyfall_participant = spyfall_participant_fixture()

      assert %Ecto.Changeset{} =
               SpyfallParticipants.change_spyfall_participant(spyfall_participant)
    end
  end
end
