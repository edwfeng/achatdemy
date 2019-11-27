defmodule AchatdemyWeb.Resolvers.Chats do
  alias Achatdemy.Chats

  def list_chats(_, args, %{context: %{current_user: %{id: uid}}}) do
    chats = Achatdemy.Users.list_perms_uid(uid)
    |> Enum.map(fn perm -> perm.comm_id end)
    |> IO.inspect
    |> Chats.get_chats(args)
    |> IO.inspect
    {:ok, chats}
  end

  def list_chat(_, %{id: id}, %{context: %{current_user: %{id: uid}}}) do
    chat = Chats.get_chat!(id)

    case Achatdemy.Users.get_perm([chat.comm_id], %{user_id: uid}) do
      nil ->
        {:error, "Chat does not exist."}
      _ ->
        {:ok, chat}
    end
  end

  def list_widgets(_, %{chat_id: chat_id}, %{context: %{current_user: %{id: uid}}}) do
    comms = Achatdemy.Users.list_perms_uid(uid)
    |> Enum.map(fn perm -> perm.comm_id end)

    chat = Chats.get_chat!(chat_id)

    case Enum.member?(comms, chat.comm_id) do
      false ->
        {:error, "Chat does not exist."}
      _ ->
        {:ok, Chats.get_widget_chat(chat_id)}
    end
  end

  def list_widget(_, %{id: id}, %{context: %{current_user: %{id: uid}}}) do
    comms = Achatdemy.Users.list_perms_uid(uid)
    |> Enum.map(fn perm -> perm.comm_id end)

    widget = Chats.get_widget!(id)
    chat = Chats.get_chat!(widget.chat_id)

    case Enum.member?(comms, chat.comm_id) do
      false ->
        {:error, "Chat does not exist."}
      _ ->
        {:ok, widget}
    end
  end

  def create_chat(_, args, %{context: %{current_user: %{id: uid}}}) do
    IO.inspect(Map.put(args, :user_id, uid))
    case Chats.create_chat(Map.put(args, :user_id, uid)) do
      {:ok, chat} ->
        {:ok, chat}
      _err ->
        {:error, "Could not create chat."}
    end
  end
end
