defmodule GameTogetherOnline.Authorization.UserRoleTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Authorization.UserRole
  alias GameTogetherOnline.Repo
  alias Ecto.UUID

  import GameTogetherOnline.AuthorizationFixtures
  import GameTogetherOnline.AccountsFixtures

  setup do
    role = role_fixture()
    user = user_fixture()

    {:ok, %{valid_attrs: %{user_id: user.id, role_id: role.id}}}
  end

  test "is invalid without a user", %{valid_attrs: valid_attrs} do
    refute UserRole.changeset(%UserRole{}, Map.delete(valid_attrs, :user_id)).valid?
  end

  test "is invalid without a role", %{valid_attrs: valid_attrs} do
    refute UserRole.changeset(%UserRole{}, Map.delete(valid_attrs, :role_id)).valid?
  end

  test "is invalid with an invalid user", %{valid_attrs: valid_attrs} do
    assert {:error, _changeset} =
             %UserRole{}
             |> UserRole.changeset(Map.put(valid_attrs, :user_id, UUID.generate()))
             |> Repo.insert()
  end

  test "is invalid with an invalid role", %{valid_attrs: valid_attrs} do
    assert {:error, _changeset} =
             %UserRole{}
             |> UserRole.changeset(Map.put(valid_attrs, :role_id, UUID.generate()))
             |> Repo.insert()
  end

  test "is invalid when the user already has the given role", %{valid_attrs: valid_attrs} do
    {:ok, _role} =
      %UserRole{}
      |> UserRole.changeset(valid_attrs)
      |> Repo.insert()

    assert {:error, _changeset} =
             %UserRole{}
             |> UserRole.changeset(valid_attrs)
             |> Repo.insert()
  end

  test "is valid with valid attributes", %{valid_attrs: valid_attrs} do
    assert UserRole.changeset(%UserRole{}, valid_attrs).valid?
  end
end
