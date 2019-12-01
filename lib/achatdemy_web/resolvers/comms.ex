defmodule AchatdemyWeb.Resolvers.Comms do
  alias Achatdemy.Comms
  alias Achatdemy.Users

  def list_comms(_, args, _) do
    {:ok, Comms.get_comms(args)}
  end

  def list_comm(_, args, _) do
    {:ok, Comms.get_comm(args)}
  end

  def create_comm(_, args, %{context: %{current_user: %{id: uid}}}) do
    case Comms.create_comm(args) do
      {:ok, comm} ->
        case Users.link_user_comm(uid, comm.id, %{chmod: 63}) do
          _ ->
            {:ok, comm}
        end
      _ ->
        {:error, "Could not create comm."}
    end
  end

  def edit_comm(_, %{id: id} = args, _) do
    comm = Comms.get_comm!(id)
    case Comms.update_comm(comm, args) do
      {:ok, comm} ->
        {:ok, comm}
      _ ->
        {:error, "Could not edit comm."}
    end
  end
end
