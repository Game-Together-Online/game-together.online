defmodule GameTogetherOnlineWeb.ChatLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  import GameTogetherOnline.Administration.ChatsFixtures
  import GameTogetherOnline.Administration.GameTypesFixtures

  alias GameTogetherOnline.Tables

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{table_id: ""}

  defp create_chat(_) do
    chat = chat_fixture()
    %{chat: chat}
  end

  describe "Index" do
    setup [:create_chat]

    test "lists all chats", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/administration/chats")

      assert html =~ "Listing Chats"
    end

    test "saves new chat", %{conn: conn} do
      game_type = game_type_fixture(%{slug: "spyfall"})
      {:ok, table} = Tables.create_table(game_type, %{})
      create_attrs = Map.put(@create_attrs, :table_id, table.id)
      {:ok, index_live, _html} = live(conn, ~p"/administration/chats")

      assert index_live |> element("a", "New Chat") |> render_click() =~
               "New Chat"

      assert_patch(index_live, ~p"/administration/chats/new")

      assert index_live
             |> form("#chat-form", chat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#chat-form", chat: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/chats")

      assert html =~ "Chat created successfully"
    end

    test "updates chat in listing", %{conn: conn, chat: chat} do
      game_type = game_type_fixture(%{slug: "spyfall"})
      {:ok, table} = Tables.create_table(game_type, %{})
      update_attrs = Map.put(@update_attrs, :table_id, table.id)

      {:ok, index_live, _html} = live(conn, ~p"/administration/chats")

      assert index_live |> element("#chats-#{chat.id} a", "Edit") |> render_click() =~
               "Edit Chat"

      assert_patch(index_live, ~p"/administration/chats/#{chat}/edit")

      assert index_live
             |> form("#chat-form", chat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#chat-form", chat: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/chats")

      assert html =~ "Chat updated successfully"
    end

    test "deletes chat in listing", %{conn: conn, chat: chat} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/chats")

      assert index_live |> element("#chats-#{chat.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#chat-#{chat.id}")
    end
  end

  describe "Show" do
    setup [:create_chat]

    test "displays chat", %{conn: conn, chat: chat} do
      {:ok, _show_live, html} = live(conn, ~p"/administration/chats/#{chat}")

      assert html =~ "Show Chat"
    end

    test "updates chat within modal", %{conn: conn, chat: chat} do
      game_type = game_type_fixture(%{slug: "spyfall"})
      {:ok, table} = Tables.create_table(game_type, %{})
      update_attrs = Map.put(@update_attrs, :table_id, table.id)
      {:ok, show_live, _html} = live(conn, ~p"/administration/chats/#{chat}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Chat"

      assert_patch(show_live, ~p"/administration/chats/#{chat}/show/edit")

      assert show_live
             |> form("#chat-form", chat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#chat-form", chat: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/chats/#{chat}")

      assert html =~ "Chat updated successfully"
    end
  end
end
