defmodule AchatdemyWeb.Resolvers.Chats do
  alias Achatdemy.Chats

  def list_chats(_, params, %{context: %{current_user: %{id: uid}}}) when is_map(params) do
    chats = Achatdemy.Users.list_user_perms_user(uid)
    |> Enum.map(fn perm -> perm.comm_id end)
    |> IO.inspect
    |> Chats.get_chats(params)
    |> IO.inspect
    {:ok, chats}
  end

  def list_chat(_, %{id: id}, %{context: %{current_user: %{id: uid}}}) do
    chat = Chats.get_chat!(id)
    case Achatdemy.Users.get_perm(uid, chat.comm_id) do
      nil -> {:error, "The chat does not exist."}
      _ -> {:ok, chat}
    end
  end

  def list_widgets(_, %{chat_id: chat_id}, _) do
    {:ok, Chats.get_widget_chat(chat_id)}
  end

  def list_widgets(_, _, _) do
    {:ok, Chats.list_widgets()}
  end

  def list_widget(_, %{id: id}, _) do
    {:ok, Chats.get_widget!(id)}
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
