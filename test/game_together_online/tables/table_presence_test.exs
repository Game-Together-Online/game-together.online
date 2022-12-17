defmodule GameTogetherOnline.Tables.TablePresenceTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Tables.TablePresence
  alias GameTogetherOnline.Repo
  alias Ecto.UUID

  import GameTogetherOnline.Administration.PlayersFixtures
  import GameTogetherOnline.Administration.TablesFixtures

  setup :generate_valid_attrs

  test "is invalid without a player id", valid_attrs do
    refute TablePresence.changeset(%TablePresence{}, Map.delete(valid_attrs, :player_id)).valid?
  end

  test "is invalid without an invalid player id", valid_attrs do
    invalid_attrs = Map.put(valid_attrs, :player_id, UUID.generate())

    assert {:error, _changeset} =
             Repo.insert(TablePresence.changeset(%TablePresence{}, invalid_attrs))
  end

  test "is invalid without a table id", valid_attrs do
    refute TablePresence.changeset(%TablePresence{}, Map.delete(valid_attrs, :table_id)).valid?
  end

  test "is invalid without an invalid table id", valid_attrs do
    invalid_attrs = Map.put(valid_attrs, :table_id, UUID.generate())

    assert {:error, _changeset} =
             Repo.insert(TablePresence.changeset(%TablePresence{}, invalid_attrs))
  end

  test "is invalid with a duplicate player id and table id", valid_attrs do
    assert {:ok, _table_presence} =
             Repo.insert(TablePresence.changeset(%TablePresence{}, valid_attrs))

    assert {:error, _changeset} =
             Repo.insert(TablePresence.changeset(%TablePresence{}, valid_attrs))
  end

  test "is valid with valid attributes", valid_attrs do
    assert TablePresence.changeset(%TablePresence{}, valid_attrs).valid?
  end

  def generate_valid_attrs(_) do
    player = player_fixture()
    table = table_fixture()
    {:ok, %{player_id: player.id, table_id: table.id}}
  end
end
