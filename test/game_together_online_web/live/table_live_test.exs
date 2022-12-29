defmodule GameTogetherOnlineWeb.TableLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  alias GameTogetherOnline.Tables
  alias GameTogetherOnline.Tables.PresenceServer
  alias GameTogetherOnline.Administration.PlayersFixtures
  alias GameTogetherOnline.Administration.GameTypesFixtures
  alias GameTogetherOnline.Administration.ChatMessages
  alias GameTogetherOnline.Administration.NicknameChangeEvents
  alias GameTogetherOnline.NicknameChangeEvents.NicknameChangeChatEvent
  alias GameTogetherOnline.Repo
  alias Ecto.UUID

  setup :create_table

  describe "Lobby" do
    test "shows the edit nickname modal when the edit_nickname query param is present", %{
      conn: conn,
      table: table
    } do
      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby?edit_nickname")
      assert html =~ "change-nickname-modal"
    end

    test "raises an error with an invalid table id", %{conn: conn} do
      assert_raise Ecto.Query.CastError, fn -> live(conn, ~p"/tables/table-id/lobby") end
    end

    test "raises an error with an table id that doesn't reference a table", %{conn: conn} do
      table_id = UUID.generate()
      assert_raise Ecto.NoResultsError, fn -> live(conn, ~p"/tables/#{table_id}/lobby") end
    end

    test "shows the lobby when the table exists", %{conn: conn, table: table} do
      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby")

      assert html =~ "Welcome to the game,"
      assert html =~ "Copy Invite Link"
      refute html =~ "change-nickname-modal"
    end

    test "shows the spades lobby for spades tables", %{conn: conn} do
      spades_game_type = GameTypesFixtures.game_type_fixture(%{slug: "spades"})
      {:ok, table} = Tables.create_table(spades_game_type, %{})
      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby")

      assert html =~ "SPADES"
    end

    test "shows the spyfall lobby for spyfall tables", %{conn: conn, table: table} do
      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby")

      assert html =~ "SPYFALL"
    end

    test "allows players to update their nickname", %{conn: conn, table: table} do
      start_supervised!(PresenceServer)
      conn = get(conn, ~p"/tables/#{table.id}/lobby")
      %{current_player: current_player} = conn.assigns
      {:ok, index_live, _html} = live(conn, ~p"/tables/#{table.id}/lobby")

      assert index_live |> element("a", "Change Your Nickname") |> render_click() =~
               "Save"

      assert_patch(index_live, ~p"/tables/#{table.id}/lobby?tab=chat&edit_nickname=true")

      assert index_live
             |> form("#change-nickname-form", player: %{nickname: ""})
             |> render_change() =~ "can&#39;t be blank"

      index_live
      |> form("#change-nickname-form", player: %{nickname: "New Nickname"})
      |> render_submit()

      assert_patch(index_live, ~p"/tables/#{table.id}/lobby?tab=chat")

      [nickname_change_event] = NicknameChangeEvents.list_nickname_change_events()
      assert nickname_change_event.new_nickname == "New Nickname"
      assert nickname_change_event.original_nickname == current_player.nickname
      assert nickname_change_event.player_id == current_player.id

      [nickname_change_chat_event] = Repo.all(NicknameChangeChatEvent)
      assert nickname_change_chat_event.nickname_change_event_id == nickname_change_event.id
    end

    test "shows the chat tab by default", %{conn: conn, table: table} do
      start_supervised!(PresenceServer)
      {:ok, index_live, _html} = live(conn, ~p"/tables/#{table.id}/lobby")

      index_live
      |> form("#chat_message-form", chat_message: %{content: "some chat message content"})
      |> render_submit()

      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby")
      assert html =~ "some chat message content"
      assert render(index_live) =~ "joined"
      assert render(index_live) =~ "left"
    end

    test "shows the chat tab when it has been selected", %{conn: conn, table: table} do
      start_supervised!(PresenceServer)
      conn = get(conn, ~p"/tables/#{table.id}/lobby")
      {:ok, index_live, _html} = live(conn, ~p"/tables/#{table.id}/lobby")

      index_live
      |> form("#chat_message-form", chat_message: %{content: "some chat message content"})
      |> render_submit()

      assert render(index_live) =~ "some chat message content"

      {:ok, index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby?tab=chat")

      assert html =~ "some chat message content"
      assert render(index_live) =~ "joined"
      assert render(index_live) =~ "left"
    end

    test "shows the players present tab when it has been selected", %{conn: conn, table: table} do
      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby?tab=players_present")

      refute html =~ "Current tab: chat"
    end

    test "shows an empty state for the players present tab", %{conn: conn, table: table} do
      {:ok, _index_live, html} = live(conn, ~p"/tables/#{table.id}/lobby?tab=players_present")

      assert html =~ "There&#39;s nobody else here"
    end

    test "shows the players present", %{conn: conn, table: table} do
      start_supervised!(PresenceServer)
      other_player = PlayersFixtures.player_fixture()
      Tables.track_presence(table, other_player)

      {:ok, index_live, _html} = live(conn, ~p"/tables/#{table.id}/lobby?tab=players_present")

      assert render(index_live) =~ other_player.nickname
    end

    test "maintains the players present tab when the player updates their nickname", %{
      conn: conn,
      table: table
    } do
      {:ok, index_live, _html} = live(conn, ~p"/tables/#{table.id}/lobby?tab=players_present")

      assert index_live |> element("a", "Change Your Nickname") |> render_click() =~
               "Save"

      refute index_live
             |> form("#change-nickname-form", player: %{nickname: "New Nickname"})
             |> render_submit() =~
               "Current tab: chat"
    end

    test "switches to the players present tab", %{conn: conn, table: table} do
      conn = get(conn, ~p"/tables/#{table.id}/lobby")
      {:ok, index_live, _html} = live(conn, ~p"/tables/#{table.id}/lobby")

      assert index_live
             |> element("button", "Players Present")
             |> render_click() =~ conn.assigns.current_player.nickname
    end

    test "allows creating chat messages", %{conn: conn, table: table} do
      conn = get(conn, ~p"/tables/#{table.id}/lobby")

      current_player = conn.assigns.current_player

      {:ok, index_live, _html} = live(conn, ~p"/tables/#{table.id}/lobby")

      index_live
      |> form("#chat_message-form", chat_message: %{content: "some content"})
      |> render_submit()

      [chat_message] = ChatMessages.list_chat_messages()

      assert chat_message.content == "some content"
      assert chat_message.chat_id == table.chat.id
      assert chat_message.player_id == current_player.id
    end

    def create_table(_) do
      spyfall_game_type = GameTypesFixtures.game_type_fixture(%{slug: "spyfall"})
      {:ok, table} = Tables.create_table(spyfall_game_type, %{})
      {:ok, %{table: table}}
    end
  end
end
