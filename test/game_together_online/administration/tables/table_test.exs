defmodule GameTogetherOnline.Administration.Tables.TableTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.Tables.Table

  @valid_attrs %{status: "game-pending"}

  test "is invalid without a status" do
    refute Table.changeset(%Table{}, Map.delete(@valid_attrs, :status)).valid?
  end

  test "is invalid with an invalid status" do
    refute Table.changeset(%Table{}, Map.put(@valid_attrs, :status, "something")).valid?
  end

  test "is valid with valid attributes" do
    assert Table.changeset(%Table{}, Map.put(@valid_attrs, :status, "game-pending")).valid?
  end
end
