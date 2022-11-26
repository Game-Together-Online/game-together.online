defmodule GameTogetherOnline.Administration.Users.User do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :confirmed_at, :naive_datetime

    timestamps()
  end
end
