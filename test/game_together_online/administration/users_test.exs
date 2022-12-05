defmodule GameTogetherOnline.Administration.UsersTest do
  use GameTogetherOnline.DataCase

  alias GameTogetherOnline.Administration.Users
  import GameTogetherOnline.AccountsFixtures
  import GameTogetherOnline.Administration.PlayersFixtures

  describe "users" do
    test "list_users_without_players_by_email/1 returns all with a similar email" do
      user_fixture(%{email: "some-email@bees.net"})
      user = user_fixture(%{email: "oThErUsEr@test.org"})

      [loaded_user] = Users.list_users_without_players_by_email("otheruser")
      assert equal?(user, loaded_user)
    end

    test "list_users_without_players_by_email/1 limits the result list to 10 if no page size has been given" do
      for i <- 1..15, do: user_fixture(%{email: "some-email-#{i}@beans.org"})

      assert "some-eMaIl"
             |> Users.list_users_without_players_by_email()
             |> length() == 10
    end

    test "list_users_without_players_by_email/1 limits the result list to the given page size" do
      for i <- 1..15, do: user_fixture(%{email: "some-email-#{i}@beans.org"})

      assert "some-eMaIl"
             |> Users.list_users_without_players_by_email(page_size: 5)
             |> length() == 5
    end

    test "list_users_without_players_by_email/1 only returns users without players" do
      for i <- 1..15 do
        user = user_fixture(%{email: "some-email-#{i}@beans.org"})
        player_fixture(%{nickname: "some-nickname-#{i}", user_id: user.id})
      end

      assert ""
             |> Users.list_users_without_players_by_email(page_size: 5)
             |> length() == 0
    end

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
