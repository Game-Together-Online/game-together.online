defmodule GameTogetherOnline.Administration.SpyfallTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.Spyfall

  describe "locations" do
    alias GameTogetherOnline.Administration.Spyfall.Location

    import GameTogetherOnline.Administration.SpyfallFixtures

    @invalid_attrs %{name: nil}

    test "list_locations/0 returns all locations" do
      location = location_fixture()
      assert Spyfall.list_locations() == [location]
    end

    test "get_location!/1 returns the location with given id" do
      location = location_fixture()
      assert Spyfall.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Location{} = location} = Spyfall.create_location(valid_attrs)
      assert location.name == "some name"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Spyfall.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Location{} = location} = Spyfall.update_location(location, update_attrs)
      assert location.name == "some updated name"
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = Spyfall.update_location(location, @invalid_attrs)
      assert location == Spyfall.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      location = location_fixture()
      assert {:ok, %Location{}} = Spyfall.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> Spyfall.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      location = location_fixture()
      assert %Ecto.Changeset{} = Spyfall.change_location(location)
    end
  end
end
