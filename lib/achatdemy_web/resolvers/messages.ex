defmodule AchatdemyWeb.Resolvers.Messages do
  alias Achatdemy.Messages

  def list_messages(_, args, %{context: %{current_user: %{id: uid}}}) do
    comms = Achatdemy.Users.list_perms_uid(uid)
    |> Enum.map(fn perm -> perm.comm_id end)

    {:ok, Messages.get_messages(comms, args)}
  end

  def list_message(_, %{id: id}, %{context: %{current_user: %{id: uid}}}) do
    comms = Achatdemy.Users.list_perms_uid(uid)
    |> Enum.map(fn perm -> perm.comm_id end)

    msg = Messages.get_message!(id)
    chat = Achatdemy.Chats.get_chat!(msg.chat_id)

    case Enum.member?(comms, chat.comm_id) do
      false ->
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
    comms = Achatdemy.Users.list_perms_uid(uid)
    |> Enum.map(fn perm -> perm.comm_id end)

    file = Messages.get_file!(id)
    msg = Messages.get_message!(file.message_id)
    chat = Achatdemy.Chats.get_chat!(msg.chat_id)

    case Enum.member?(comms, chat.comm_id) do
      false ->
        {:error, "File does not exist."}
      _ ->
        {:ok, file}
    end
  end

  def create_message(_, args, %{context: %{current_user: %{id: uid}}}) do
    case Messages.create_message(Map.put(args, :user_id, uid)) do
      {:ok, message} ->
        {:ok, message}
      _ ->
        {:error, "Could not create message."}
    end
  end
end
