defmodule GameTogetherOnlineWeb.Administration.NicknameChangeEventLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  import GameTogetherOnline.Administration.NicknameChangeEventsFixtures
  import GameTogetherOnline.Administration.PlayersFixtures

  @create_attrs %{new_nickname: "some new_nickname", original_nickname: "some original_nickname"}
  @update_attrs %{
    new_nickname: "some updated new_nickname",
    original_nickname: "some updated original_nickname"
  }
  @invalid_attrs %{new_nickname: nil, original_nickname: nil}

  defp create_nickname_change_event(_) do
    nickname_change_event = nickname_change_event_fixture()
    %{nickname_change_event: nickname_change_event}
  end

  describe "Index" do
    setup [:create_nickname_change_event]

    test "lists all nickname_change_events", %{
      conn: conn,
      nickname_change_event: nickname_change_event
    } do
      {:ok, _index_live, html} = live(conn, ~p"/administration/nickname_change_events")

      assert html =~ "Listing Nickname change events"
      assert html =~ nickname_change_event.new_nickname
    end

    test "saves new nickname_change_event", %{conn: conn} do
      player = player_fixture()
      create_attrs = Map.put(@create_attrs, :player_id, player.id)
      {:ok, index_live, _html} = live(conn, ~p"/administration/nickname_change_events")

      assert index_live |> element("a", "New Nickname change event") |> render_click() =~
               "New Nickname change event"

      assert_patch(index_live, ~p"/administration/nickname_change_events/new")

      assert index_live
             |> form("#nickname_change_event-form", nickname_change_event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#nickname_change_event-form", nickname_change_event: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/nickname_change_events")

      assert html =~ "Nickname change event created successfully"
      assert html =~ "some new_nickname"
    end

    test "updates nickname_change_event in listing", %{
      conn: conn,
      nickname_change_event: nickname_change_event
    } do
      {:ok, index_live, _html} = live(conn, ~p"/administration/nickname_change_events")

      assert index_live
             |> element("#nickname_change_events-#{nickname_change_event.id} a", "Edit")
             |> render_click() =~
               "Edit Nickname change event"

      assert_patch(
        index_live,
        ~p"/administration/nickname_change_events/#{nickname_change_event}/edit"
      )

      assert index_live
             |> form("#nickname_change_event-form", nickname_change_event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#nickname_change_event-form", nickname_change_event: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/nickname_change_events")

      assert html =~ "Nickname change event updated successfully"
      assert html =~ "some updated new_nickname"
    end

    test "deletes nickname_change_event in listing", %{
      conn: conn,
      nickname_change_event: nickname_change_event
    } do
      {:ok, index_live, _html} = live(conn, ~p"/administration/nickname_change_events")

      assert index_live
             |> element("#nickname_change_events-#{nickname_change_event.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#nickname_change_event-#{nickname_change_event.id}")
    end
  end

  describe "Show" do
    setup [:create_nickname_change_event]

    test "displays nickname_change_event", %{
      conn: conn,
      nickname_change_event: nickname_change_event
    } do
      {:ok, _show_live, html} =
        live(conn, ~p"/administration/nickname_change_events/#{nickname_change_event}")

      assert html =~ "Show Nickname change event"
      assert html =~ nickname_change_event.new_nickname
    end

    test "updates nickname_change_event within modal", %{
      conn: conn,
      nickname_change_event: nickname_change_event
    } do
      {:ok, show_live, _html} =
        live(conn, ~p"/administration/nickname_change_events/#{nickname_change_event}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Nickname change event"

      assert_patch(
        show_live,
        ~p"/administration/nickname_change_events/#{nickname_change_event}/show/edit"
      )

      assert show_live
             |> form("#nickname_change_event-form", nickname_change_event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#nickname_change_event-form", nickname_change_event: @update_attrs)
        |> render_submit()
        |> follow_redirect(
          conn,
          ~p"/administration/nickname_change_events/#{nickname_change_event}"
        )

      assert html =~ "Nickname change event updated successfully"
      assert html =~ "some updated new_nickname"
    end
  end
end
