defmodule AchatdemyWeb.Resolvers.Chats do
  alias Achatdemy.Chats

  def list_chats(_, args, %{context: %{current_user: %{id: uid}}}) do
    chats = Achatdemy.Users.list_perms_uid(uid)
    |> Enum.map(fn perm -> perm.comm_id end)
    |> Chats.get_chats(args)
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
    case Chats.create_chat(Map.put(args, :user_id, uid)) do
      {:ok, chat} ->
        {:ok, chat}
      _ ->
        {:error, "Could not create chat."}
    end
  end

  def create_widget(_, args, %{context: %{current_user: %{id: uid}}}) do
    comms = Achatdemy.Users.list_perms_uid(uid)
    |> Enum.map(fn perm -> perm.comm_id end)

    chat = Chats.get_chat!(args.chat_id)

    case Enum.member?(comms, chat.comm_id) do
      false ->
        {:error, "Chat does not exist."}
      true ->
        case Chats.create_widget(Map.put(args, :user_id, uid)) do
          {:ok, widget} ->
            {:ok, widget}
          _ ->
            {:error, "Could not create widget"}
        end
    end
  end

  def edit_widget(_, args, %{context: %{current_user: %{id: uid}}}) do
    comms = Achatdemy.Users.list_perms_uid(uid)
    |> Enum.map(fn perm -> perm.comm_id end)

    widget = Chats.get_widget!(args.id)
    chat = Chats.get_chat!(widget.chat_id)

    case Enum.member?(comms, chat.comm_id) do
      false ->
        {:error, "Widget does not exist."}
      true ->
        case Chats.update_widget(widget, args) do
          {:ok, widget} ->
            {:ok, widget}
          _ ->
            {:error, "Could not edit widget."}
        end
    end
  end

  def delete_widget(_, args, %{context: %{current_user: %{id: uid}}}) do
    comms = Achatdemy.Users.list_perms_uid(uid)
    |> Enum.map(fn perm -> perm.comm_id end)

    widget = Chats.get_widget!(args.id)
    chat = Chats.get_chat!(widget.chat_id)

    case Enum.member?(comms, chat.comm_id) do
      false ->
        {:error, "Widget does not exist."}
      true ->
        case Chats.delete_widget(widget) do
          {:ok, widget} ->
            {:ok, widget}
          _ ->
            {:error, "Could not delete widget."}
        end
    end
  end
end
