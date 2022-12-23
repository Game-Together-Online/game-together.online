defmodule GameTogetherOnline.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  alias GameTogetherOnline.Administration.Tables.Table

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chats" do
    belongs_to :table, Table

    timestamps()
  end

  # TODO: Test this
  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:table_id])
    |> validate_required([:table_id])
    |> foreign_key_constraint(:table_id)
  end
end
