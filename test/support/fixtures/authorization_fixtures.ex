defmodule GameTogetherOnline.AuthorizationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameTogetherOnline.Authorization` context.
  """

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        slug: "administrator"
      })
      |> GameTogetherOnline.Authorization.create_role()

    role
  end
end
