defmodule GameTogetherOnline.Administration.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias GameTogetherOnline.Repo

  alias GameTogetherOnline.Administration.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def list_users_without_players_by_email(email, opts \\ []) do
    email_filter = "%" <> email <> "%"
    page_size = Keyword.get(opts, :page_size, 10)

    Repo.all(
      from u in User,
        left_join: p in assoc(u, :player),
        where: ilike(u.email, ^email_filter),
        where: is_nil(p.id),
        limit: ^page_size,
        order_by: [asc: u.email]
    )
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)
end
