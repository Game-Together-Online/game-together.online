defmodule GameTogetherOnlineWeb.Administration.GameTypeLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  import GameTogetherOnline.Administration.GameTypesFixtures

  @create_attrs %{description: "some description", name: "some name", slug: "spades"}
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    slug: "spades"
  }
  @invalid_attrs %{description: nil, name: nil, slug: nil}

  defp create_game_type(_) do
    game_type = game_type_fixture()
    %{game_type: game_type}
  end

  describe "Index" do
    test "links back to the administration page", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/game_types")

      assert index_live
             |> element("a", "Back to administration")
             |> render_click() ==
               {:error, {:live_redirect, %{kind: :push, to: ~p"/administration"}}}
    end

    test "lists all game_types", %{conn: conn} do
      game_type = game_type_fixture()
      {:ok, _index_live, html} = live(conn, ~p"/administration/game_types")

      assert html =~ "Listing Game types"
      assert html =~ game_type.description
    end

    test "saves new game_type", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/game_types")

      assert index_live |> element("a", "New Game type") |> render_click() =~
               "New Game type"

      assert_patch(index_live, ~p"/administration/game_types/new")

      assert index_live
             |> form("#game_type-form", game_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#game_type-form", game_type: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/game_types")

      assert html =~ "Game type created successfully"
      assert html =~ "some description"
    end

    test "updates game_type in listing", %{conn: conn} do
      game_type = game_type_fixture()
      {:ok, index_live, _html} = live(conn, ~p"/administration/game_types")

      assert index_live |> element("#game_types-#{game_type.id} a", "Edit") |> render_click() =~
               "Edit Game type"

      assert_patch(index_live, ~p"/administration/game_types/#{game_type}/edit")

      assert index_live
             |> form("#game_type-form", game_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#game_type-form", game_type: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/game_types")

      assert html =~ "Game type updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes game_type in listing", %{conn: conn} do
      game_type = game_type_fixture()
      {:ok, index_live, _html} = live(conn, ~p"/administration/game_types")

      assert index_live |> element("#game_types-#{game_type.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#game_type-#{game_type.id}")
    end
  end

  describe "Show" do
    setup [:create_game_type]

    test "displays game_type", %{conn: conn, game_type: game_type} do
      {:ok, _show_live, html} = live(conn, ~p"/administration/game_types/#{game_type}")

      assert html =~ "Show Game type"
      assert html =~ game_type.description
    end

    test "updates game_type within modal", %{conn: conn, game_type: game_type} do
      {:ok, show_live, _html} = live(conn, ~p"/administration/game_types/#{game_type}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Game type"

      assert_patch(show_live, ~p"/administration/game_types/#{game_type}/show/edit")

      assert show_live
             |> form("#game_type-form", game_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#game_type-form", game_type: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/game_types/#{game_type}")

      assert html =~ "Game type updated successfully"
      assert html =~ "some updated description"
    end
  end
end
