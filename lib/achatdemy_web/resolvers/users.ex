defmodule AchatdemyWeb.Resolvers.Users do
  alias Achatdemy.Users
  alias Achatdemy.Perms

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

  def create_perm(_, args, %{context: %{current_user: %{id: uid}}}) do
    u_perms = Users.list_perms_uid(uid)
    |> Enum.filter(fn perm -> perm.comm_id == args.comm_id end)

    case u_perms do
      [u_perm | _] ->
        u_perm_map = Perms.get_perm_map(u_perm.chmod)

        case u_perm_map.admin do
          false ->
            {:error, "You are not allowed to modify perms in this chat."}
          true ->
            chmod = Perms.create_perms(args.perms)

            case Users.create_perm(Map.put(args, :chmod, chmod)) do
              {:ok, perm} ->
                {:ok, perm}
              _ ->
                {:error, "Could not create perm."}
            end
        end
      _ ->
        {:error, "Comm does not exist."}
    end
  end

  def edit_perm(_, args, %{context: %{current_user: %{id: uid}}}) do
    u_perms = Users.list_perms_uid(uid)
    |> Enum.filter(fn perm -> perm.comm_id == args.comm_id end)

    case u_perms do
      [u_perm | _] ->
        u_perm_map = Perms.get_perm_map(u_perm.chmod)

        case u_perm_map.admin do
          false ->
            {:error, "You are not allowed to modify perms in this chat."}
          true ->
            edit_perm_check_dupe(args)
        end
      _ ->
        {:error, "Comm does not exist."}
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
    chmod = Perms.get_raw_perm_map(perm.chmod)
    |> Map.merge(args.perms)
    |> Perms.create_perms()

    case Users.update_perm(perm, %{chmod: chmod}) do
      {:ok, perm} ->
        {:ok, perm}
      _ ->
        {:error, "Could not edit perm."}
    end
  end

  def delete_perm(_, args, %{context: %{current_user: %{id: uid}}}) do
    u_perms = Users.list_perms_uid(uid)
    |> Enum.filter(fn perm -> perm.comm_id == args.comm_id end)

    case u_perms do
      [u_perm | _] ->
        u_perm_map = Perms.get_perm_map(u_perm.chmod)

        case u_perm_map.admin do
          false ->
            {:error, "You are not allowed to modify perms in this chat."}
          true ->
            delete_perm_check_dupe(args)
        end
      _ ->
        {:error, "Comm does not exist."}
    end
  end

  defp delete_perm_check_dupe(args) do
    current_admins = Users.get_perms([args.comm_id])
    |> Enum.filter(fn perm -> Perms.get_perm_map(perm.chmod).admin end)

    case length(current_admins) do
      1 ->
        {:error, "Cannot remove only admin."}
      _ ->
        perm = Users.get_perm([args.comm_id], %{user_id: args.user_id})
        case Users.delete_perm(perm) do
          {:ok, perm} ->
            {:ok, perm}
          _ ->
            {:error, "Could not delete perm."}
        end
    end
  end
end
