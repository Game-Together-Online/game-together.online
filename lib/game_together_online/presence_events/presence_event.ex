defmodule GameTogetherOnline.PresenceEvents.PresenceEvent do
  use Ecto.Schema
  import Ecto.Changeset

  alias GameTogetherOnline.Players.Player

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "presence_events" do
    field :type, :string

    field :chat_id, :binary_id
    belongs_to :player, Player

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(presence_event, attrs) do
    presence_event
    |> cast(attrs, [:type, :chat_id, :player_id])
    |> validate_required([:type, :chat_id, :player_id])
    |> foreign_key_constraint(:chat_id)
    |> foreign_key_constraint(:player_id)
    |> validate_inclusion(:type, ["join", "leave"])
  end
end
