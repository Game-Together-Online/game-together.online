defmodule GameTogetherOnline.Roles.RoleTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Authorization.Role
  alias GameTogetherOnline.Authorization

  import GameTogetherOnline.AuthorizationFixtures

  @valid_attrs %{
    name: "Administrator",
    description: "administrator role description",
    slug: "administrator"
  }

  test "is invalid without a name" do
    refute Role.changeset(%Role{}, Map.delete(@valid_attrs, :name)).valid?
  end

  test "is invalid without a description" do
    refute Role.changeset(%Role{}, Map.delete(@valid_attrs, :description)).valid?
  end

  test "is invalid with a description which is too long" do
    description =
      "A description which is too long and should not be valid. Hopefully, the validation will fail. I need to add something here to make it long enough."

    refute Role.changeset(
             %Role{},
             Map.put(@valid_attrs, :description, description <> description)
           ).valid?
  end

  test "is invalid without a slug" do
    refute Role.changeset(%Role{}, Map.delete(@valid_attrs, :slug)).valid?
  end

  test "is invalid with an invalid slug" do
    refute Role.changeset(%Role{}, Map.put(@valid_attrs, :slug, "invalid-slug")).valid?
  end

  test "is invalid with a duplicate slug" do
    role = role_fixture()

    assert {:error, _changeset} =
             Authorization.create_role(Map.put(@valid_attrs, :slug, role.slug))
  end

  test "is valid with valid attributes" do
    assert Role.changeset(%Role{}, @valid_attrs).valid?
  end
end
