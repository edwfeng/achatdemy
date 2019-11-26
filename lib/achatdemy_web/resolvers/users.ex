defmodule AchatdemyWeb.Resolvers.Users do
  alias Achatdemy.Users

  def list_users(_, args, _) do
    {:ok, Users.get_users(args)}
  end

  def list_user(_, args, _) do
    {:ok, Users.get_user(args)}
  end

  def current_user(_, _, %{context: %{current_user: %{id: uid}}}) do
    {:ok, Users.get_user(%{id: uid})}
  end

  def list_perms(_, args, %{context: %{current_user: %{id: uid}}}) do
    perms = Users.list_perms_uid(uid)
    |> Enum.map(fn perm -> perm.comm_id end)
    |> Users.get_perms(args)
    {:ok, perms}
  end
end
