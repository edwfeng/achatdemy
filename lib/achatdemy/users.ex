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

  def get_users(args) when is_map(args) do
    get_user_query(args)
    |> Repo.all
  end

  def get_user(args) when is_map(args) do
    get_user_query(args)
    |> Repo.one
  end

  defp get_user_query(args) when is_map(args) do
    query = User
    args
    |> Enum.reduce(query, fn {arg, val}, query ->
      binding = [{arg, val}]
      query
      |> where(^binding)
    end)
  end

  def user_login(username, password) do
    user = User
           |> where(username: ^username)
           |> Repo.one

    case user do
      %{password: ^password}
        ->
          Achatdemy.Guardian.encode_and_sign(user)
      _
        ->
          {:error, "User and password does not match."}
    end
  end

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

  def list_perms_uid(uid) do
    Perm
    |> where(user_id: ^uid)
    |> Repo.all()
  end

  def get_perms(comms, args) when is_list(comms) and is_map(args) do
    get_perm_query(comms, args)
    |> Repo.all
  end

  def get_perm(comms, args) when is_list(comms) and is_map(args) do
    get_perm_query(comms, args)
    |> Repo.one
  end

  defp get_perm_query(comms, args) when is_list(comms) and is_map(args) do
    query = Perm
    |> where([perm], perm.comm_id in ^comms)

    args
    |> Enum.reduce(query, fn {arg, val}, query ->
      binding = [{arg, val}]
      query
      |> where(^binding)
    end)
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

  def link_user_comm(user_id, comm_id, attrs) when is_map(attrs) do
    %Perm{
      user_id: user_id,
      comm_id: comm_id
    }
    |> Perm.changeset(attrs)
    |> Repo.insert!
  end

  def unlink_user_comm(user_id, comm_id) do
    Perm
    |> where(user_id: ^user_id)
    |> where(comm_id: ^comm_id)
    |> Repo.delete_all
  end

  def get_perms_by_users(_model, ids) do
    Achatdemy.Users.Perm
    |> where([perm], perm.user_id in ^ids)
    |> Repo.all()
    |> Enum.group_by(&(&1.user_id))
  end

  def get_chats_by_users(_model, ids) do
    Achatdemy.Chats.Chat
    |> where([chat], chat.user_id in ^ids)
    |> Repo.all()
    |> Enum.group_by(&(&1.user_id))
  end

  def get_messages_by_users(_model, ids) do
    Achatdemy.Messages.Message
    |> where([msg], msg.user_id in ^ids)
    |> Repo.all()
    |> Enum.group_by(&(&1.user_id))
  end

  def get_user_by_perms(_model, ids) do
    Achatdemy.Users.User
    |> where([user], user.id in ^ids)
    |> Repo.all()
    |> Map.new(&{&1.id, &1})
  end

  def get_comm_by_perms(_model, ids) do
    Achatdemy.Comms.Comm
    |> where([comm], comm.id in ^ids)
    |> Repo.all()
    |> Map.new(&{&1.id, &1})
  end
end
