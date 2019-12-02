defmodule AchatdemyWeb.Resolvers.Comms do
  alias Achatdemy.Comms
  alias Achatdemy.Users
  alias Achatdemy.Perms

  def list_comms(_, args, _) do
    {:ok, Comms.get_comms(args)}
  end

  def list_comm(_, args, _) do
    {:ok, Comms.get_comm(args)}
  end

  def create_comm(_, args, %{context: %{current_user: %{id: uid}}}) do
    case Comms.create_comm(args) do
      {:ok, comm} ->
        chmod = Perms.create_perms(%{admin: true})
        Users.link_user_comm(uid, comm.id, %{chmod: chmod})
        {:ok, comm}
      _ ->
        {:error, "Could not create comm."}
    end
  end

  def edit_comm(_, %{id: id} = args, %{context: %{current_user: %{id: uid}}}) do
    perms = Users.list_perms_uid(uid)
    |> Enum.filter(fn perm -> perm.comm_id == args.id end)

    case perms do
      [perm | _] ->
        perm_map = Perms.get_perm_map(perm.chmod)

        case perm_map.mod_comm do
          false ->
            {:error, "You are not allowed to modify this comm."}
          true ->
            comm = Comms.get_comm!(id)
            case Comms.update_comm(comm, args) do
              {:ok, comm} ->
                {:ok, comm}
              _ ->
                {:error, "Could not edit comm."}
            end
        end
      _ ->
        {:error, "Comm does not exist."}
    end
  end
end
