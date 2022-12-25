defmodule GameTogetherOnline.Administration.NicknameChangeEventsTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.NicknameChangeEvents

  describe "nickname_change_events" do
    alias GameTogetherOnline.Administration.NicknameChangeEvents.NicknameChangeEvent

    import GameTogetherOnline.Administration.NicknameChangeEventsFixtures
    import GameTogetherOnline.Administration.PlayersFixtures

    @invalid_attrs %{new_nickname: nil, original_nickname: nil}

    test "list_nickname_change_events/0 returns all nickname_change_events" do
      nickname_change_event = nickname_change_event_fixture()
      assert NicknameChangeEvents.list_nickname_change_events() == [nickname_change_event]
    end

    test "get_nickname_change_event!/1 returns the nickname_change_event with given id" do
      nickname_change_event = nickname_change_event_fixture()

      assert NicknameChangeEvents.get_nickname_change_event!(nickname_change_event.id) ==
               nickname_change_event
    end

    test "create_nickname_change_event/1 with valid data creates a nickname_change_event" do
      player = player_fixture()

      valid_attrs = %{
        player_id: player.id,
        new_nickname: "some new_nickname",
        original_nickname: "some original_nickname"
      }

      assert {:ok, %NicknameChangeEvent{} = nickname_change_event} =
               NicknameChangeEvents.create_nickname_change_event(valid_attrs)

      assert nickname_change_event.new_nickname == "some new_nickname"
      assert nickname_change_event.original_nickname == "some original_nickname"
    end

    test "create_nickname_change_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               NicknameChangeEvents.create_nickname_change_event(@invalid_attrs)
    end

    test "update_nickname_change_event/2 with valid data updates the nickname_change_event" do
      nickname_change_event = nickname_change_event_fixture()

      update_attrs = %{
        new_nickname: "some updated new_nickname",
        original_nickname: "some updated original_nickname"
      }

      assert {:ok, %NicknameChangeEvent{} = nickname_change_event} =
               NicknameChangeEvents.update_nickname_change_event(
                 nickname_change_event,
                 update_attrs
               )

      assert nickname_change_event.new_nickname == "some updated new_nickname"
      assert nickname_change_event.original_nickname == "some updated original_nickname"
    end

    test "update_nickname_change_event/2 with invalid data returns error changeset" do
      nickname_change_event = nickname_change_event_fixture()

      assert {:error, %Ecto.Changeset{}} =
               NicknameChangeEvents.update_nickname_change_event(
                 nickname_change_event,
                 @invalid_attrs
               )

      assert nickname_change_event ==
               NicknameChangeEvents.get_nickname_change_event!(nickname_change_event.id)
    end

    test "delete_nickname_change_event/1 deletes the nickname_change_event" do
      nickname_change_event = nickname_change_event_fixture()

      assert {:ok, %NicknameChangeEvent{}} =
               NicknameChangeEvents.delete_nickname_change_event(nickname_change_event)

      assert_raise Ecto.NoResultsError, fn ->
        NicknameChangeEvents.get_nickname_change_event!(nickname_change_event.id)
      end
    end

    test "change_nickname_change_event/1 returns a nickname_change_event changeset" do
      nickname_change_event = nickname_change_event_fixture()

      assert %Ecto.Changeset{} =
               NicknameChangeEvents.change_nickname_change_event(nickname_change_event)
    end
  end
end
