defmodule GameTogetherOnline.Administration.PresenceEventsTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.PresenceEvents

  describe "presence_events" do
    alias GameTogetherOnline.Administration.PresenceEvents.PresenceEvent

    import GameTogetherOnline.Administration.PresenceEventsFixtures
    import GameTogetherOnline.Administration.ChatsFixtures
    import GameTogetherOnline.Administration.PlayersFixtures

    @invalid_attrs %{type: nil}

    test "list_presence_events/0 returns all presence_events" do
      presence_event = presence_event_fixture()
      assert PresenceEvents.list_presence_events() == [presence_event]
    end

    test "get_presence_event!/1 returns the presence_event with given id" do
      presence_event = presence_event_fixture()
      assert PresenceEvents.get_presence_event!(presence_event.id) == presence_event
    end

    test "create_presence_event/1 with valid data creates a presence_event" do
      chat = chat_fixture()
      player = player_fixture()
      valid_attrs = %{type: "join", player_id: player.id, chat_id: chat.id}

      assert {:ok, %PresenceEvent{} = presence_event} =
               PresenceEvents.create_presence_event(valid_attrs)

      assert presence_event.type == "join"
      assert presence_event.chat_id == chat.id
      assert presence_event.player_id == player.id
    end

    test "create_presence_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PresenceEvents.create_presence_event(@invalid_attrs)
    end

    test "update_presence_event/2 with valid data updates the presence_event" do
      presence_event = presence_event_fixture(%{type: "join"})
      update_attrs = %{type: "leave"}

      assert {:ok, %PresenceEvent{} = presence_event} =
               PresenceEvents.update_presence_event(presence_event, update_attrs)

      assert presence_event.type == "leave"
    end

    test "update_presence_event/2 with invalid data returns error changeset" do
      presence_event = presence_event_fixture()

      assert {:error, %Ecto.Changeset{}} =
               PresenceEvents.update_presence_event(presence_event, @invalid_attrs)

      assert presence_event == PresenceEvents.get_presence_event!(presence_event.id)
    end

    test "delete_presence_event/1 deletes the presence_event" do
      presence_event = presence_event_fixture()
      assert {:ok, %PresenceEvent{}} = PresenceEvents.delete_presence_event(presence_event)

      assert_raise Ecto.NoResultsError, fn ->
        PresenceEvents.get_presence_event!(presence_event.id)
      end
    end

    test "change_presence_event/1 returns a presence_event changeset" do
      presence_event = presence_event_fixture()
      assert %Ecto.Changeset{} = PresenceEvents.change_presence_event(presence_event)
    end
  end
end
