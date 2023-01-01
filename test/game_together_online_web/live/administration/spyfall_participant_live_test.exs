defmodule GameTogetherOnlineWeb.Administration.SpyfallParticipantLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  import GameTogetherOnline.Administration.SpyfallParticipantsFixtures
  alias GameTogetherOnline.Tables
  alias GameTogetherOnline.Administration.GameTypesFixtures
  alias GameTogetherOnline.Administration.PlayersFixtures

  @create_attrs %{ready_to_start: true}
  @update_attrs %{ready_to_start: false}
  @invalid_attrs %{ready_to_start: false, player_id: "", spyfall_game_id: ""}

  defp create_spyfall_participant(_) do
    spyfall_participant = spyfall_participant_fixture()
    %{spyfall_participant: spyfall_participant}
  end

  describe "Index" do
    setup [:create_spyfall_participant]

    test "lists all spyfall_participants", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/administration/spyfall_participants")

      assert html =~ "Listing Spyfall participants"
    end

    test "saves new spyfall_participant", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/spyfall_participants")

      assert index_live |> element("a", "New Spyfall participant") |> render_click() =~
               "New Spyfall participant"

      assert_patch(index_live, ~p"/administration/spyfall_participants/new")

      assert index_live
             |> form("#spyfall_participant-form", spyfall_participant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      spyfall = GameTypesFixtures.game_type_fixture(%{slug: "spyfall"})
      {:ok, table} = Tables.create_table(spyfall, %{})
      player = PlayersFixtures.player_fixture()

      create_attrs =
        @create_attrs
        |> Map.put(:spyfall_game_id, table.spyfall_game.id)
        |> Map.put(:player_id, player.id)

      {:ok, _, html} =
        index_live
        |> form("#spyfall_participant-form", spyfall_participant: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/spyfall_participants")

      assert html =~ "Spyfall participant created successfully"
    end

    test "updates spyfall_participant in listing", %{
      conn: conn,
      spyfall_participant: spyfall_participant
    } do
      {:ok, index_live, _html} = live(conn, ~p"/administration/spyfall_participants")

      assert index_live
             |> element("#spyfall_participants-#{spyfall_participant.id} a", "Edit")
             |> render_click() =~
               "Edit Spyfall participant"

      assert_patch(
        index_live,
        ~p"/administration/spyfall_participants/#{spyfall_participant}/edit"
      )

      assert index_live
             |> form("#spyfall_participant-form", spyfall_participant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      update_attrs =
        @update_attrs
        |> Map.put(:ready_to_start, !spyfall_participant.ready_to_start)
        |> Map.put(:spyfall_game_id, spyfall_participant.spyfall_game_id)
        |> Map.put(:player_id, spyfall_participant.player_id)

      {:ok, _, html} =
        index_live
        |> form("#spyfall_participant-form", spyfall_participant: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/spyfall_participants")

      assert html =~ "Spyfall participant updated successfully"
    end

    test "deletes spyfall_participant in listing", %{
      conn: conn,
      spyfall_participant: spyfall_participant
    } do
      {:ok, index_live, _html} = live(conn, ~p"/administration/spyfall_participants")

      assert index_live
             |> element("#spyfall_participants-#{spyfall_participant.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#spyfall_participant-#{spyfall_participant.id}")
    end
  end

  describe "Show" do
    setup [:create_spyfall_participant]

    test "displays spyfall_participant", %{conn: conn, spyfall_participant: spyfall_participant} do
      {:ok, _show_live, html} =
        live(conn, ~p"/administration/spyfall_participants/#{spyfall_participant}")

      assert html =~ "Show Spyfall participant"
    end

    test "updates spyfall_participant within modal", %{
      conn: conn,
      spyfall_participant: spyfall_participant
    } do
      {:ok, show_live, _html} =
        live(conn, ~p"/administration/spyfall_participants/#{spyfall_participant}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Spyfall participant"

      assert_patch(
        show_live,
        ~p"/administration/spyfall_participants/#{spyfall_participant}/show/edit"
      )

      assert show_live
             |> form("#spyfall_participant-form", spyfall_participant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      update_attrs =
        @update_attrs
        |> Map.put(:ready_to_start, !spyfall_participant.ready_to_start)
        |> Map.put(:spyfall_game_id, spyfall_participant.spyfall_game_id)
        |> Map.put(:player_id, spyfall_participant.player_id)

      {:ok, _, html} =
        show_live
        |> form("#spyfall_participant-form", spyfall_participant: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/spyfall_participants/#{spyfall_participant}")

      assert html =~ "Spyfall participant updated successfully"
    end
  end
end
