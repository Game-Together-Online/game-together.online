defmodule GameTogetherOnlineWeb.PresenceEventLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  import GameTogetherOnline.Administration.PresenceEventsFixtures
  import GameTogetherOnline.Administration.PlayersFixtures

  alias GameTogetherOnline.Tables

  @create_attrs %{type: "leave"}
  @update_attrs %{type: "leave"}
  @invalid_attrs %{type: nil}

  defp create_presence_event(_) do
    presence_event = presence_event_fixture()
    %{presence_event: presence_event}
  end

  describe "Index" do
    setup [:create_presence_event]

    test "lists all presence_events", %{conn: conn, presence_event: presence_event} do
      {:ok, _index_live, html} = live(conn, ~p"/administration/presence_events")

      assert html =~ "Listing Presence events"
      assert html =~ presence_event.type
    end

    test "saves new presence_event", %{conn: conn} do
      {:ok, table} = Tables.create_table(%{slug: "spades"}, %{})
      player = player_fixture()

      create_attrs =
        @create_attrs
        |> Map.put(:chat_id, table.chat.id)
        |> Map.put(:player_id, player.id)

      {:ok, index_live, _html} = live(conn, ~p"/administration/presence_events")

      assert index_live |> element("a", "New Presence event") |> render_click() =~
               "New Presence event"

      assert_patch(index_live, ~p"/administration/presence_events/new")

      assert index_live
             |> form("#presence_event-form", presence_event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#presence_event-form", presence_event: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/presence_events")

      assert html =~ "Presence event created successfully"
      assert html =~ "leave"
      assert html =~ table.chat.id
      assert html =~ player.id
    end

    test "updates presence_event in listing", %{conn: conn, presence_event: presence_event} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/presence_events")

      assert index_live
             |> element("#presence_events-#{presence_event.id} a", "Edit")
             |> render_click() =~
               "Edit Presence event"

      assert_patch(index_live, ~p"/administration/presence_events/#{presence_event}/edit")

      assert index_live
             |> form("#presence_event-form", presence_event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#presence_event-form", presence_event: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/presence_events")

      assert html =~ "Presence event updated successfully"
      assert html =~ "leave"
    end

    test "deletes presence_event in listing", %{conn: conn, presence_event: presence_event} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/presence_events")

      assert index_live
             |> element("#presence_events-#{presence_event.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#presence_event-#{presence_event.id}")
    end
  end

  describe "Show" do
    setup [:create_presence_event]

    test "displays presence_event", %{conn: conn, presence_event: presence_event} do
      {:ok, _show_live, html} = live(conn, ~p"/administration/presence_events/#{presence_event}")

      assert html =~ "Show Presence event"
      assert html =~ presence_event.type
      assert html =~ presence_event.chat_id
      assert html =~ presence_event.player_id
    end

    test "updates presence_event within modal", %{conn: conn, presence_event: presence_event} do
      {:ok, show_live, _html} = live(conn, ~p"/administration/presence_events/#{presence_event}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Presence event"

      assert_patch(show_live, ~p"/administration/presence_events/#{presence_event}/show/edit")

      assert show_live
             |> form("#presence_event-form", presence_event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#presence_event-form", presence_event: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/presence_events/#{presence_event}")

      assert html =~ "Presence event updated successfully"
      assert html =~ "leave"
    end
  end
end
