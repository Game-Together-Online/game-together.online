defmodule GameTogetherOnlineWeb.PageControllerTest do
  use GameTogetherOnlineWeb.ConnCase

  import GameTogetherOnline.GameTypesFixtures

  test "GET /", %{conn: conn} do
    game_type = game_type_fixture()
    conn = get(conn, ~p"/")

    response = html_response(conn, 200)

    assert response =~ game_type.name
    assert response =~ game_type.description
  end
end
