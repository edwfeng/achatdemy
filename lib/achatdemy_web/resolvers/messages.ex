defmodule AchatdemyWeb.Resolvers.Messages do
  alias Achatdemy.Messages
  alias Achatdemy.Users

  def list_messages(_, args, %{context: %{current_user: %{id: uid}}}) do
    comms = Achatdemy.Users.list_perms_uid(uid)
    |> Enum.map(fn perm -> perm.comm_id end)

    {:ok, Messages.get_messages(comms, args)}
  end

  def list_message(_, %{id: id}, %{context: %{current_user: %{id: uid}}}) do
    msg = Messages.get_message!(id)
    chat = Achatdemy.Chats.get_chat!(msg.chat_id)

    case Users.get_perm([chat.comm_id], %{user_id: uid}) do
      nil ->
        {:error, "Message does not exist."}
      _ ->
        {:ok, msg}
    end
  end

  def list_files(_, args, %{context: %{current_user: %{id: uid}}}) do
    comms = Achatdemy.Users.list_perms_uid(uid)
    |> Enum.map(fn perm -> perm.comm_id end)

    {:ok, Messages.get_files(comms, args)}
  end

  def list_file(_, %{id: id}, %{context: %{current_user: %{id: uid}}}) do
    file = Messages.get_file!(id)
    msg = Messages.get_message!(file.message_id)
    chat = Achatdemy.Chats.get_chat!(msg.chat_id)

    case Users.get_perm([chat.comm_id], %{user_id: uid}) do
      nil ->
        {:error, "File does not exist."}
      _ ->
        {:ok, file}
    end
  end

  def create_message(_, args, %{context: %{current_user: %{id: uid}}}) do
    chat = Achatdemy.Chats.get_chat!(args.chat_id)

    case Users.get_perm([chat.comm_id], %{user_id: uid}) do
      nil ->
        {:error, "Chat does not exist."}
      perm ->
        case chat.user_id == uid do
          true ->
            create_message_helper(Map.put(args, :user_id, uid))
          false ->
            perm_map = Achatdemy.Perms.get_perm_map(perm.chmod)

            case perm_map.create_msg do
              true ->
                create_message_helper(Map.put(args, :user_id, uid))
              false ->
                {:error, "You are not allowed to create messages in this comm."}
            end
        end
    end
  end

  defp create_message_helper(args) do
    case Messages.create_message(args) do
      {:ok, message} ->
        {:ok, message}
      _ ->
        {:error, "Could not create message."}
    end
  end
end
