defmodule GameTogetherOnline.Authorization.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  alias GameTogetherOnline.Accounts.User
  alias GameTogetherOnline.Authorization.Role

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_roles" do
    belongs_to :user, User
    belongs_to :role, Role

    timestamps()
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:user_id, :role_id])
    |> validate_required([:user_id, :role_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:role_id)
    |> unique_constraint([:user_id, :role_id], name: :user_roles_role_id_user_id_index)
  end
end
