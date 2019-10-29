defmodule AchatdemyWeb.Resolvers.Chats do
  alias Achatdemy.Chats

  def list_chats(_, %{comm_id: comm_id}, _) do
    {:ok, Chats.get_chats_comm(comm_id)}
  end

  def list_chats(_, %{user_id: user_id}, _) do
    {:ok, Chats.get_chats_user(user_id)}
  end

  def list_chats(_, %{type: type}, _) do
    {:ok, Chats.get_chats_type(type)}
  end

  def list_chats(_, _, _) do
    {:ok, Chats.list_chats()}
  end

  def list_chat(_, %{id: id}, _) do
    {:ok, Chats.get_chat!(id)}
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
end
