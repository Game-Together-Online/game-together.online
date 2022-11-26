defmodule GameTogetherOnline.Administration.UsersTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.Users
  import GameTogetherOnline.AccountsFixtures

  describe "users" do
    test "list_users/0 returns all users" do
      user = user_fixture()
      [loaded_user] = Users.list_users()

      assert equal?(user, loaded_user)
    end

    test "get_player!/1 returns the player with given id" do
      user = user_fixture()
      loaded_user = Users.get_user!(user.id)

      assert equal?(user, loaded_user)
    end

    defp equal?(first_user, second_user) do
      first_user.id == second_user.id &&
        first_user.email == second_user.email
    end
  end
end
