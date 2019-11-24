defmodule AchatdemyWeb.Resolvers.Messages do
  alias Achatdemy.Messages

  def list_messages(_, %{chat_id: chat_id}, _) do
    {:ok, Messages.get_messages_chat(chat_id)}
  end

  def list_messages(_, %{user_id: user_id}, _) do
    {:ok, Messages.get_messages_user(user_id)}
  end

  def list_messages(_, _, _) do
    {:ok, Messages.list_messages()}
  end

  def list_message(_, %{id: id}, _) do
    {:ok, Messages.get_message!(id)}
  end

  def list_files(_, _, _) do
    {:ok, Messages.list_files()}
  end

  def list_file(_, %{id: id}, _) do
    {:ok, Messages.get_file!(id)}
  end

  def create_message(_, args, %{context: %{current_user: %{id: uid}}}) do
    case Messages.create_message(Map.put(args, :user_id, uid)) do
      {:ok, message} ->
        {:ok, message}
      _err ->
        {:error, "Could not create message."}
    end
  end
end
