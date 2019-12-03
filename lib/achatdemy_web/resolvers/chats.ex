defmodule AchatdemyWeb.Resolvers.Chats do
  alias Achatdemy.Chats
  alias Achatdemy.Users
  alias Achatdemy.Perms

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
    chat = Chats.get_chat!(chat_id)

    case Users.get_perm([chat.comm_id], %{user_id: uid}) do
      nil ->
        {:error, "Chat does not exist."}
      _ ->
        {:ok, Chats.get_widget_chat(chat_id)}
    end
  end

  def list_widget(_, %{id: id}, %{context: %{current_user: %{id: uid}}}) do
    widget = Chats.get_widget!(id)
    chat = Chats.get_chat!(widget.chat_id)

    case Users.get_perm([chat.comm_id], %{user_id: uid}) do
      nil ->
        {:error, "Chat does not exist."}
      _ ->
        {:ok, widget}
    end
  end

  def create_chat(_, args, %{context: %{current_user: %{id: uid}}}) do
    case Users.get_perm([args.comm_id], %{user_id: uid}) do
      nil ->
        {:error, "Comm does not exist."}
      perm ->
        perm_map = Perms.get_perm_map(perm.chmod)

        case perm_map.create_chat do
          false ->
            {:error, "You are not allowed to create chats in this comm."}
          true ->
            case Chats.create_chat(Map.put(args, :user_id, uid)) do
              {:ok, chat} ->
                {:ok, chat}
              _ ->
                {:error, "Could not create chat."}
            end
        end
    end
  end

  def create_widget(_, args, %{context: %{current_user: %{id: uid}}}) do
    chat = Chats.get_chat!(args.chat_id)

    case Users.get_perm([chat.comm_id], %{user_id: uid}) do
      nil ->
        {:error, "Chat does not exist."}
      perm ->
        case chat.user_id == uid do
          true ->
            create_widget_helper(args)
          false ->
            perm_map = Perms.get_perm_map(perm.chmod)

            case perm_map.mod_chat do
              true ->
                create_widget_helper(args)
              false ->
                {:error, "You are not allowed to edit chats in this comm."}
            end
        end
    end
  end

  defp create_widget_helper(args) do
    case Chats.create_widget(args) do
      {:ok, widget} ->
        {:ok, widget}
      _ ->
        {:error, "Could not create widget."}
    end
  end

  def edit_widget(_, args, %{context: %{current_user: %{id: uid}}}) do
    widget = Chats.get_widget!(args.id)
    chat = Chats.get_chat!(widget.chat_id)

    case Users.get_perm([chat.comm_id], %{user_id: uid}) do
      nil ->
        {:error, "Chat does not exist."}
      perm ->
        case chat.user_id == uid do
          true ->
            edit_widget_helper(widget, args)
          false ->
            perm_map = Perms.get_perm_map(perm.chmod)

            case perm_map.mod_chat do
              true ->
                edit_widget_helper(widget, args)
              false ->
                {:error, "You are not allowed to edit chats in this comm."}
            end
        end
    end
  end

  defp edit_widget_helper(widget, args) do
    case Chats.update_widget(widget, args) do
      {:ok, widget} ->
        {:ok, widget}
      _ ->
        {:error, "Could not edit widget."}
    end
  end

  def delete_widget(_, args, %{context: %{current_user: %{id: uid}}}) do
    widget = Chats.get_widget!(args.id)
    chat = Chats.get_chat!(widget.chat_id)

    case Users.get_perm([chat.comm_id], %{user_id: uid}) do
      nil ->
        {:error, "Chat does not exist."}
      perm ->
        case chat.user_id == uid do
          true ->
            delete_widget_helper(widget)
          false ->
            perm_map = Perms.get_perm_map(perm.chmod)

            case perm_map.mod_chat do
              true ->
                delete_widget_helper(widget)
              false ->
                {:error, "You are not allowed to edit chats in this comm."}
            end
        end
    end
  end

  defp delete_widget_helper(widget) do
    case Chats.delete_widget(widget) do
      {:ok, widget} ->
        {:ok, widget}
      _ ->
        {:error, "Could not delete widget."}
    end
  end
end
