defmodule GameTogetherOnlineWeb.Administration.ChatMessageLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  import GameTogetherOnline.Administration.ChatMessagesFixtures
  import GameTogetherOnline.Administration.PlayersFixtures

  alias GameTogetherOnline.Administration.GameTypes
  alias GameTogetherOnline.Tables

  @create_attrs %{content: "some content"}
  @update_attrs %{content: "some updated content"}
  @invalid_attrs %{content: nil}

  defp create_chat_message(_) do
    chat_message = chat_message_fixture()
    %{chat_message: chat_message}
  end

  describe "Index" do
    setup [:create_chat_message]

    test "lists all chat_messages", %{conn: conn, chat_message: chat_message} do
      {:ok, _index_live, html} = live(conn, ~p"/administration/chat_messages")

      assert html =~ "Listing Chat messages"
      assert html =~ chat_message.content
    end

    test "saves new chat_message", %{conn: conn} do
      [game_type] = GameTypes.list_game_types()
      {:ok, table} = Tables.create_table(game_type, %{})
      player = player_fixture()
      create_attrs = Enum.into(@create_attrs, %{player_id: player.id, chat_id: table.chat.id})

      {:ok, index_live, _html} = live(conn, ~p"/administration/chat_messages")

      assert index_live |> element("a", "New Chat message") |> render_click() =~
               "New Chat message"

      assert_patch(index_live, ~p"/administration/chat_messages/new")

      assert index_live
             |> form("#chat_message-form", chat_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#chat_message-form", chat_message: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/chat_messages")

      assert html =~ "Chat message created successfully"
      assert html =~ "some content"
    end

    test "updates chat_message in listing", %{conn: conn, chat_message: chat_message} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/chat_messages")

      assert index_live
             |> element("#chat_messages-#{chat_message.id} a", "Edit")
             |> render_click() =~
               "Edit Chat message"

      assert_patch(index_live, ~p"/administration/chat_messages/#{chat_message}/edit")

      assert index_live
             |> form("#chat_message-form", chat_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#chat_message-form", chat_message: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/chat_messages")

      assert html =~ "Chat message updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes chat_message in listing", %{conn: conn, chat_message: chat_message} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/chat_messages")

      assert index_live
             |> element("#chat_messages-#{chat_message.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#chat_message-#{chat_message.id}")
    end
  end

  describe "Show" do
    setup [:create_chat_message]

    test "displays chat_message", %{conn: conn, chat_message: chat_message} do
      {:ok, _show_live, html} = live(conn, ~p"/administration/chat_messages/#{chat_message}")

      assert html =~ "Show Chat message"
      assert html =~ chat_message.content
    end

    test "updates chat_message within modal", %{conn: conn, chat_message: chat_message} do
      {:ok, show_live, _html} = live(conn, ~p"/administration/chat_messages/#{chat_message}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Chat message"

      assert_patch(show_live, ~p"/administration/chat_messages/#{chat_message}/show/edit")

      assert show_live
             |> form("#chat_message-form", chat_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#chat_message-form", chat_message: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/chat_messages/#{chat_message}")

      assert html =~ "Chat message updated successfully"
      assert html =~ "some updated content"
    end
  end
end
