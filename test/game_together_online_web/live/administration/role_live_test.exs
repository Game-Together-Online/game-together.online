defmodule GameTogetherOnlineWeb.Administration.RoleLiveTest do
  use GameTogetherOnlineWeb.ConnCase

  import Phoenix.LiveViewTest
  import GameTogetherOnline.AuthorizationFixtures

  @create_attrs %{description: "some description", name: "some name", slug: "administrator"}
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    slug: "administrator"
  }
  @invalid_attrs %{description: nil, name: nil, slug: nil}

  defp create_role(_) do
    role = role_fixture()
    %{role: role}
  end

  describe "Index" do
    test "lists all roles", %{conn: conn} do
      %{role: role} = create_role(nil)
      {:ok, _index_live, html} = live(conn, ~p"/administration/roles")

      assert html =~ "Listing Roles"
      assert html =~ role.description
    end

    test "saves new role", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/administration/roles")

      assert index_live |> element("a", "New Role") |> render_click() =~
               "New Role"

      assert_patch(index_live, ~p"/administration/roles/new")

      assert index_live
             |> form("#role-form", role: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#role-form", role: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/roles")

      assert html =~ "Role created successfully"
      assert html =~ "some description"
    end

    test "updates role in listing", %{conn: conn} do
      %{role: role} = create_role(nil)
      {:ok, index_live, _html} = live(conn, ~p"/administration/roles")

      assert index_live |> element("#roles-#{role.id} a", "Edit") |> render_click() =~
               "Edit Role"

      assert_patch(index_live, ~p"/administration/roles/#{role}/edit")

      assert index_live
             |> form("#role-form", role: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#role-form", role: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/roles")

      assert html =~ "Role updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes role in listing", %{conn: conn} do
      %{role: role} = create_role(nil)
      {:ok, index_live, _html} = live(conn, ~p"/administration/roles")

      assert index_live |> element("#roles-#{role.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#role-#{role.id}")
    end
  end

  describe "Show" do
    setup [:create_role]

    test "displays role", %{conn: conn, role: role} do
      {:ok, _show_live, html} = live(conn, ~p"/administration/roles/#{role}")

      assert html =~ "Show Role"
      assert html =~ role.description
    end

    test "updates role within modal", %{conn: conn, role: role} do
      {:ok, show_live, _html} = live(conn, ~p"/administration/roles/#{role}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Role"

      assert_patch(show_live, ~p"/administration/roles/#{role}/show/edit")

      assert show_live
             |> form("#role-form", role: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#role-form", role: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/administration/roles/#{role}")

      assert html =~ "Role updated successfully"
      assert html =~ "some updated description"
    end
  end
end
