defmodule GameTogetherOnline.Tables.TableTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Tables.Table
  alias GameTogetherOnline.Repo
  alias Ecto.UUID

  import GameTogetherOnline.Administration.GameTypesFixtures

  @valid_attrs %{status: "game-pending", chat: %{}}

  test "is invalid without a status" do
    game_type = game_type_fixture()
    valid_attrs = Map.put(@valid_attrs, :game_type_id, game_type.id)
    refute Table.changeset(%Table{}, Map.delete(valid_attrs, :status)).valid?
  end

  test "is invalid without a game type" do
    refute Table.changeset(%Table{}, Map.delete(@valid_attrs, :status)).valid?
  end

  test "is invalid without an invalid game type" do
    invalid_attrs = Map.put(@valid_attrs, :game_type_id, UUID.generate())
    assert {:error, _changeset} = Repo.insert(Table.changeset(%Table{}, invalid_attrs))
  end

  test "is invalid with an invalid status" do
    game_type = game_type_fixture()
    valid_attrs = Map.put(@valid_attrs, :game_type_id, game_type.id)
    refute Table.changeset(%Table{}, Map.put(valid_attrs, :status, "something")).valid?
  end

  test "is valid with valid attributes" do
    game_type = game_type_fixture()
    valid_attrs = Map.put(@valid_attrs, :game_type_id, game_type.id)
    assert Table.changeset(%Table{}, Map.put(valid_attrs, :status, "game-pending")).valid?
  end
end
