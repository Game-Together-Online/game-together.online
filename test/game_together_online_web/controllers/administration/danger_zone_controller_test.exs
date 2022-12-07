defmodule GameTogetherOnlineWeb.Administration.DangerZoneControllerTest do
  use GameTogetherOnlineWeb.ConnCase

  test "GET /danger_zone", %{conn: conn} do
    conn = get(conn, ~p"/administration/danger_zone")
    assert html_response(conn, 200) =~ "THE DANGER ZONE"
  end
end
