defmodule GameTogetherOnlineWeb.Administration.SpyfallGameLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  import GameTogetherOnline.Administration.SpyfallGamesFixtures
  alias GameTogetherOnline.Administration.GameTypesFixtures
  alias GameTogetherOnline.Tables

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{table_id: nil}

  defp create_spyfall_game(_) do
    game_type = GameTypesFixtures.game_type_fixture()
    {:ok, table} = Tables.create_table(game_type, %{})
    spyfall_game = spyfall_game_fixture(%{table_id: table.id})
    %{spyfall_game: spyfall_game, table: table}
  end

  describe "Index" do
    setup [:create_spyfall_game]

    test "lists all spyfall_games", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/administration/spyfall/games")

      assert html =~ "Listing Spyfall games"
    end

    test "saves new spyfall_game", %{conn: conn, table: table} do
      create_attrs = Map.put(@create_attrs, :table_id, table.id)
      {:ok, index_live, _html} = live(conn, ~p"/administration/spyfall/games")

      assert index_live |> element("a", "New Spyfall game") |> render_click() =~
               "New Spyfall game"

      assert_patch(index_live, ~p"/administration/spyfall/games/new")

      assert index_live
             |> form("#spyfall_game-form", spyfall_game: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#spyfall_game-form", spyfall_game: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/spyfall/games")

      assert html =~ "Spyfall game created successfully"
    end

    test "updates spyfall_game in listing", %{conn: conn, spyfall_game: spyfall_game} do
      update_attrs = Map.put(@update_attrs, :table_id, spyfall_game.table_id)
      {:ok, index_live, _html} = live(conn, ~p"/administration/spyfall/games")

      assert index_live
             |> element("#spyfall_games-#{spyfall_game.id} a", "Edit")
             |> render_click() =~
               "Edit Spyfall game"

      assert_patch(index_live, ~p"/administration/spyfall/games/#{spyfall_game}/edit")

      assert index_live
             |> form("#spyfall_game-form", spyfall_game: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#spyfall_game-form", spyfall_game: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/spyfall/games")

      assert html =~ "Spyfall game updated successfully"
    end

    test "deletes spyfall_game in listing", %{conn: conn, spyfall_game: spyfall_game} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/spyfall/games")

      assert index_live
             |> element("#spyfall_games-#{spyfall_game.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#spyfall_game-#{spyfall_game.id}")
    end
  end

  describe "Show" do
    setup [:create_spyfall_game]

    test "displays spyfall_game", %{conn: conn, spyfall_game: spyfall_game} do
      {:ok, _show_live, html} = live(conn, ~p"/administration/spyfall/games/#{spyfall_game}")

      assert html =~ "Show Spyfall game"
    end

    test "updates spyfall_game within modal", %{conn: conn, spyfall_game: spyfall_game} do
      update_attrs = Map.put(@update_attrs, :table_id, spyfall_game.table_id)
      {:ok, show_live, _html} = live(conn, ~p"/administration/spyfall/games/#{spyfall_game}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Spyfall game"

      assert_patch(show_live, ~p"/administration/spyfall/games/#{spyfall_game}/show/edit")

      assert show_live
             |> form("#spyfall_game-form", spyfall_game: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#spyfall_game-form", spyfall_game: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/spyfall/games/#{spyfall_game}")

      assert html =~ "Spyfall game updated successfully"
    end
  end
end
