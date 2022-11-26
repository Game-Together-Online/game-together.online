defmodule GameTogetherOnline.Authorization.Role do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "roles" do
    field :description, :string
    field :name, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :description, :slug])
    |> validate_required([:name, :description, :slug])
    |> unique_constraint(:slug)
    |> validate_length(:description, max: 255)
    |> validate_inclusion(:slug, ["administrator"])
  end
end
