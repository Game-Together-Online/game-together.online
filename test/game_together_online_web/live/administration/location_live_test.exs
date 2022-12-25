defmodule GameTogetherOnlineWeb.Administration.LocationLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  import GameTogetherOnline.Administration.SpyfallFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_location(_) do
    location = location_fixture()
    %{location: location}
  end

  describe "Index" do
    setup [:create_location]

    test "lists all locations", %{conn: conn, location: location} do
      {:ok, _index_live, html} = live(conn, ~p"/administration/spyfall/locations")

      assert html =~ "Listing Locations"
      assert html =~ location.name
    end

    test "saves new location", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/spyfall/locations")

      assert index_live |> element("a", "New Location") |> render_click() =~
               "New Location"

      assert_patch(index_live, ~p"/administration/spyfall/locations/new")

      assert index_live
             |> form("#location-form", location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#location-form", location: %{@create_attrs | name: "some other name"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/spyfall/locations")

      assert html =~ "Location created successfully"
      assert html =~ "some other name"
    end

    test "updates location in listing", %{conn: conn, location: location} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/spyfall/locations")

      assert index_live |> element("#locations-#{location.id} a", "Edit") |> render_click() =~
               "Edit Location"

      assert_patch(index_live, ~p"/administration/spyfall/locations/#{location}/edit")

      assert index_live
             |> form("#location-form", location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#location-form", location: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/spyfall/locations")

      assert html =~ "Location updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes location in listing", %{conn: conn, location: location} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/spyfall/locations")

      assert index_live |> element("#locations-#{location.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#location-#{location.id}")
    end
  end

  describe "Show" do
    setup [:create_location]

    test "displays location", %{conn: conn, location: location} do
      {:ok, _show_live, html} = live(conn, ~p"/administration/spyfall/locations/#{location}")

      assert html =~ "Show Spyfall Location"
      assert html =~ location.name
    end

    test "updates location within modal", %{conn: conn, location: location} do
      {:ok, show_live, _html} = live(conn, ~p"/administration/spyfall/locations/#{location}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Spyfall Location"

      assert_patch(show_live, ~p"/administration/spyfall/locations/#{location}/show/edit")

      assert show_live
             |> form("#location-form", location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#location-form", location: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/spyfall/locations/#{location}")

      assert html =~ "Location updated successfully"
      assert html =~ "some updated name"
    end
  end
end
