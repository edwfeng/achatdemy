defmodule Achatdemy.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias Achatdemy.Repo

  alias Achatdemy.Chats.Chat

  @doc """
  Returns the list of chats.

  ## Examples

      iex> list_chats()
      [%Chat{}, ...]

  """
  def list_chats do
    Repo.all(Chat)
  end

  @doc """
  Gets a single chat.

  Raises `Ecto.NoResultsError` if the Chat does not exist.

  ## Examples

      iex> get_chat!(123)
      %Chat{}

      iex> get_chat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat!(id), do: Repo.get!(Chat, id)

  def get_chats(comms, args) when is_list(comms) and is_map(args) do
    query = Chat
    |> where([chat], chat.comm_id in ^comms)

    args
    |> Enum.reduce(query, fn {arg, val}, query ->
      binding = [{arg, val}]
      query
      |> where(^binding)
    end)
    |> Repo.all
  end

  def get_chats_comm(comm_id) do
    Chat
    |> where(comm_id: ^comm_id)
    |> Repo.all()
  end

  def get_chats_user(user_id) do
    Chat
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  def get_chats_type(type) do
    Chat
    |> where(type: ^type)
    |> Repo.all()
  end

  @doc """
  Creates a chat.

  ## Examples

      iex> create_chat(%{field: value})
      {:ok, %Chat{}}

      iex> create_chat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat(attrs \\ %{}) do
    %Chat{}
    |> Chat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chat.

  ## Examples

      iex> update_chat(chat, %{field: new_value})
      {:ok, %Chat{}}

      iex> update_chat(chat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat(%Chat{} = chat, attrs) do
    chat
    |> Chat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Chat.

  ## Examples

      iex> delete_chat(chat)
      {:ok, %Chat{}}

      iex> delete_chat(chat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat(%Chat{} = chat) do
    Repo.delete(chat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat changes.

  ## Examples

      iex> change_chat(chat)
      %Ecto.Changeset{source: %Chat{}}

  """
  def change_chat(%Chat{} = chat) do
    Chat.changeset(chat, %{})
  end

  alias Achatdemy.Chats.Widget

  @doc """
  Returns the list of widgets.

  ## Examples

      iex> list_widgets()
      [%Widget{}, ...]

  """
  def list_widgets do
    Repo.all(Widget)
  end

  @doc """
  Gets a single widget.

  Raises `Ecto.NoResultsError` if the Widget does not exist.

  ## Examples

      iex> get_widget!(123)
      %Widget{}

      iex> get_widget!(456)
      ** (Ecto.NoResultsError)

  """
  def get_widget!(id), do: Repo.get!(Widget, id)

  def get_widget_chat(chat_id) do
    Widget
    |> where(chat_id: ^chat_id)
    |> Repo.all()
  end

  @doc """
  Creates a widget.

  ## Examples

      iex> create_widget(%{field: value})
      {:ok, %Widget{}}

      iex> create_widget(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_widget(attrs \\ %{}) do
    %Widget{}
    |> Widget.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a widget.

  ## Examples

      iex> update_widget(widget, %{field: new_value})
      {:ok, %Widget{}}

      iex> update_widget(widget, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_widget(%Widget{} = widget, attrs) do
    widget
    |> Widget.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Widget.

  ## Examples

      iex> delete_widget(widget)
      {:ok, %Widget{}}

      iex> delete_widget(widget)
      {:error, %Ecto.Changeset{}}

  """
  def delete_widget(%Widget{} = widget) do
    Repo.delete(widget)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking widget changes.

  ## Examples

      iex> change_widget(widget)
      %Ecto.Changeset{source: %Widget{}}

  """
  def change_widget(%Widget{} = widget) do
    Widget.changeset(widget, %{})
  end

  def get_messages_by_chats(_model, ids) do
    Achatdemy.Messages.Message
    |> where([msg], msg.chat_id in ^ids)
    |> Repo.all()
    |> Enum.group_by(&(&1.chat_id))
  end

  def get_widgets_by_chats(_model, ids) do
    Achatdemy.Chats.Widget
    |> where([widget], widget.chat_id in ^ids)
    |> Repo.all()
    |> Enum.group_by(&(&1.chat_id))
  end

  def get_user_by_chats(_model, ids) do
    Achatdemy.Users.User
    |> where([user], user.id in ^ids)
    |> Repo.all()
    |> Map.new(&{&1.id, &1})
  end

  def get_comm_by_chats(_model, ids) do
    Achatdemy.Comms.Comm
    |> where([comm], comm.id in ^ids)
    |> Repo.all()
    |> Map.new(&{&1.id, &1})
  end

  def get_chat_by_widgets(_model, ids) do
    Achatdemy.Chats.Chat
    |> where([chat], chat.id in ^ids)
    |> Repo.all()
    |> Map.new(&{&1.id, &1})
  end
end
