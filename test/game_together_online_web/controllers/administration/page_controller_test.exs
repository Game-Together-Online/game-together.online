defmodule GameTogetherOnlineWeb.Administration.PageControllerTest do
  use GameTogetherOnlineWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/administration")
    assert html_response(conn, 200) =~ ~p"/administration/tables"

    assert html_response(conn, 200) =~ ~p"/administration/game_types"

    assert html_response(conn, 200) =~ ~p"/administration/players"

    assert html_response(conn, 200) =~ ~p"/administration/users"

    assert html_response(conn, 200) =~ ~p"/administration/roles"

    assert html_response(conn, 200) =~ ~p"/administration/spyfall/locations"

    assert html_response(conn, 200) =~ ~p"/administration/chats"

    assert html_response(conn, 200) =~ ~p"/administration/chat_messages"
  end
end
