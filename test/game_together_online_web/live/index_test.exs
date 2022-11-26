defmodule GameTogetherOnlineWeb.IndexTest do
  use GameTogetherOnlineWeb.ConnCase

  alias GameTogetherOnline.Administration.Tables
  import GameTogetherOnline.GameTypesFixtures
  import Phoenix.LiveViewTest

  test "GET /", %{conn: conn} do
    game_type = game_type_fixture(%{enabled: true})
    conn = get(conn, ~p"/")

    response = html_response(conn, 200)

    assert response =~ game_type.name
    assert response =~ game_type.description
  end

  describe "creating a spades game" do
    setup %{conn: conn} do
      game_type_fixture(%{slug: "spades", name: "Spades", description: "spades!", enabled: true})
      {:ok, view, _html} = live(conn, ~p"/")

      result =
        view
        |> element("button", "Spades")
        |> render_click()

      {:ok, %{result: result}}
    end

    test "creates a spades table" do
      [table] = Tables.list_tables()

      assert table.status == "game-pending"
      assert table.game_type.slug == "spades"
    end

    test "redirects to the table page", %{result: result} do
      [table] = Tables.list_tables()

      assert result ==
               {:error, {:live_redirect, %{kind: :push, to: ~p"/tables/#{table.id}/lobby"}}}
    end
  end
end
