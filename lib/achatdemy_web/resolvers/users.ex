defmodule AchatdemyWeb.Resolvers.Users do
  alias Achatdemy.Users
  alias Achatdemy.Perms

  def list_users(_, args, _) do
    {:ok, Users.get_users(args)}
  end

  def list_users_fuzzy(_, args, _) do
    args = Map.put_new(args, :threshold, 0.3)
    {:ok, Users.get_users_fuzzy(args.username, args.threshold)}
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

  def create_perm(_, args, %{context: %{current_user: %{id: uid}}}) do
    case Users.get_perm([args.comm_id], %{user_id: uid}) do
      nil ->
        {:error, "Comm does not exist."}
      u_perm ->
        u_perm_map = Perms.get_perm_map(u_perm.chmod)

        case u_perm_map.admin do
          false ->
            {:error, "You are not allowed to modify perms in this comm."}
          true ->
            chmod = Perms.create_perms(args.perms)

            case Users.create_perm(Map.put(args, :chmod, chmod)) do
              {:ok, perm} ->
                {:ok, perm}
              _ ->
                {:error, "Could not create perm."}
            end
        end
    end
  end

  def edit_perm(_, args, %{context: %{current_user: %{id: uid}}}) do
    case Users.get_perm([args.comm_id], %{user_id: uid}) do
      nil ->
        {:error, "Comm does not exist."}
      u_perm ->
        u_perm_map = Perms.get_perm_map(u_perm.chmod)

        case u_perm_map.admin do
          false ->
            {:error, "You are not allowed to modify perms in this comm."}
          true ->
            edit_perm_check_dupe(args)
        end
    end
  end

  defp edit_perm_check_dupe(args) do
    current_admins = Users.get_perms([args.comm_id])
    |> Enum.filter(fn perm -> Perms.get_perm_map(perm.chmod).admin end)

    case length(current_admins) do
      1 ->
        case args.perms[:admin] do
          false ->
            {:error, "Cannot remove only admin."}
          _ ->
            edit_perm_modify(args)
        end
      _ ->
        edit_perm_modify(args)
    end
  end

  defp edit_perm_modify(args) do
    perm = Users.get_perm([args.comm_id], %{user_id: args.user_id})
    chmod = Perms.changeset(perm.chmod, args.perms)

    case Users.update_perm(perm, %{chmod: chmod}) do
      {:ok, perm} ->
        {:ok, perm}
      _ ->
        {:error, "Could not edit perm."}
    end
  end

  def delete_perm(_, args, %{context: %{current_user: %{id: uid}}}) do
    case Users.get_perm([args.comm_id], %{user_id: uid}) do
      nil ->
        {:error, "Comm does not exist."}
      u_perm ->
        u_perm_map = Perms.get_perm_map(u_perm.chmod)

        case u_perm_map.admin do
          false ->
            {:error, "You are not allowed to modify perms in this comm."}
          true ->
            delete_perm_check_dupe(args)
        end
    end
  end

  defp delete_perm_check_dupe(args) do
    current_admins = Users.get_perms([args.comm_id])
    |> Enum.filter(fn perm -> Perms.get_perm_map(perm.chmod).admin end)
    |> Enum.map(fn perm -> perm.user_id end)

    case length(current_admins) do
      1 ->
        case Enum.member?(current_admins, args.user_id) do
          true ->
            {:error, "Cannot remove only admin."}
          _ ->
            delete_perm_modify(args)
        end
      _ ->
        delete_perm_modify(args)
    end
  end

  defp delete_perm_modify(args) do
    perm = Users.get_perm([args.comm_id], %{user_id: args.user_id})
    case Users.delete_perm(perm) do
      {:ok, perm} ->
        {:ok, perm}
      _ ->
        {:error, "Could not delete perm."}
    end
  end
end
