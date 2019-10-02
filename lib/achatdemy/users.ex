defmodule Achatdemy.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Achatdemy.Repo

  alias Achatdemy.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
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

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Achatdemy.Users.Perm

  @doc """
  Returns the list of user_perms.

  ## Examples

      iex> list_user_perms()
      [%Perm{}, ...]

  """
  def list_user_perms do
    Repo.all(Perm)
  end

  @doc """
  Gets a single perm.

  Raises `Ecto.NoResultsError` if the Perm does not exist.

  ## Examples

      iex> get_perm!(123)
      %Perm{}

      iex> get_perm!(456)
      ** (Ecto.NoResultsError)

  """
  def get_perm!(id), do: Repo.get!(Perm, id)

  def list_user_perms_user(uid) do
    Perm
    |> where(user_id: ^uid)
    |> Repo.all()
  end

  @doc """
  Creates a perm.

  ## Examples

      iex> create_perm(%{field: value})
      {:ok, %Perm{}}

      iex> create_perm(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_perm(attrs \\ %{}) do
    %Perm{}
    |> Perm.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a perm.

  ## Examples

      iex> update_perm(perm, %{field: new_value})
      {:ok, %Perm{}}

      iex> update_perm(perm, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_perm(%Perm{} = perm, attrs) do
    perm
    |> Perm.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Perm.

  ## Examples

      iex> delete_perm(perm)
      {:ok, %Perm{}}

      iex> delete_perm(perm)
      {:error, %Ecto.Changeset{}}

  """
  def delete_perm(%Perm{} = perm) do
    Repo.delete(perm)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking perm changes.

  ## Examples

      iex> change_perm(perm)
      %Ecto.Changeset{source: %Perm{}}

  """
  def change_perm(%Perm{} = perm) do
    Perm.changeset(perm, %{})
  end
end
