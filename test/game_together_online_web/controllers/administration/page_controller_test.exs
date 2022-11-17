defmodule GameTogetherOnlineWeb.Administration.PageControllerTest do
  use GameTogetherOnlineWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/administration")
    assert html_response(conn, 200) =~ ~p"/administration/tables"

    assert html_response(conn, 200) =~ ~p"/administration/game_types"
  end
end
