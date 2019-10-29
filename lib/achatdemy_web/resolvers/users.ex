defmodule AchatdemyWeb.Resolvers.Users do
  alias Achatdemy.Users

  def list_users(_, _, _) do
    {:ok, Users.list_users()}
  end

  def list_user(_, %{id: id}, _) do
    {:ok, Users.get_user!(id)}
  end

  def list_user(_, %{username: username}, _) do
    {:ok, Users.get_user_name!(username)}
  end

  def list_user(_, %{email: email}, _) do
    {:ok, Users.get_user_email!(email)}
  end

  def list_perms(_, %{user_id: user_id}, _) do
    {:ok, Users.list_user_perms_user(user_id)}
  end

  def list_perms(_, %{comm_id: comm_id}, _) do
    {:ok, Users.list_user_perms_comm(comm_id)}
  end

  def list_perms(_, _, _) do
    {:ok, Users.list_user_perms()}
  end
end
