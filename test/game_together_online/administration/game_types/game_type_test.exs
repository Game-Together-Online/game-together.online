defmodule GameTogetherOnline.Administration.GameTypes.GameTypeTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.GameTypes.GameType
  alias GameTogetherOnline.Administration.GameTypes

  @valid_attrs %{name: "Spades", description: "a game", slug: "spades"}

  test "is invalid without a name" do
    refute GameType.changeset(%GameType{}, Map.delete(@valid_attrs, :name)).valid?
  end

  test "is invalid without a description" do
    refute GameType.changeset(%GameType{}, Map.delete(@valid_attrs, :description)).valid?
  end

  test "is invalid with a description which is too long" do
    description =
      "A description which is too long and should not be valid. Hopefully, the validation will fail. I need to add something here to make it long enough."

    refute GameType.changeset(
             %GameType{},
             Map.put(@valid_attrs, :description, description <> description)
           ).valid?
  end

  test "is invalid with an invalid slug" do
    refute GameType.changeset(%GameType{}, Map.put(@valid_attrs, :slug, "invalid-slug")).valid?
  end

  test "is invalid with a duplicate slug" do
    {:ok, _game_type} = GameTypes.create_game_type(@valid_attrs)
    assert {:error, _changeset} = GameTypes.create_game_type(@valid_attrs)
  end

  test "is valid with valid attributes" do
    assert GameType.changeset(%GameType{}, @valid_attrs).valid?
  end
end
