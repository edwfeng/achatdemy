defmodule Achatdemy.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Achatdemy.Repo

  alias Achatdemy.Messages.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  def get_messages(comms, args) when is_list(comms) and is_map(args) do
    chats = Achatdemy.Chats.Chat
    |> where([chat], chat.comm_id in ^comms)
    |> Repo.all
    |> Enum.map(fn chat -> chat.id end)

    query = Message
    |> where([msg], msg.chat_id in ^chats)

    args
    |> Enum.reduce(query, fn {arg, val}, query ->
      binding = [{arg, val}]
      query
      |> where(^binding)
    end)
    |> Repo.all
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{source: %Message{}}

  """
  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end

  alias Achatdemy.Messages.File

  @doc """
  Returns the list of files.

  ## Examples

      iex> list_files()
      [%File{}, ...]

  """
  def list_files do
    Repo.all(File)
  end

  @doc """
  Gets a single file.

  Raises `Ecto.NoResultsError` if the File does not exist.

  ## Examples

      iex> get_file!(123)
      %File{}

      iex> get_file!(456)
      ** (Ecto.NoResultsError)

  """
  def get_file!(id), do: Repo.get!(File, id)

  def get_files(comms, args) when is_list(comms) and is_map(args) do
    chats = Achatdemy.Chats.Chat
    |> where([chat], chat.comm_id in ^comms)
    |> Repo.all
    |> Enum.map(fn chat -> chat.id end)

    messages = Message
    |> where([msg], msg.chat_id in ^chats)
    |> Repo.all
    |> Enum.map(fn chat -> chat.id end)

    query = File
    |> where([file], file.message_id in ^messages)

    args
    |> Enum.reduce(query, fn {arg, val}, query ->
      binding = [{arg, val}]
      query
      |> where(^binding)
    end)
    |> Repo.all
  end

  @doc """
  Creates a file.

  ## Examples

      iex> create_file(%{field: value})
      {:ok, %File{}}

      iex> create_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_file(attrs \\ %{}) do
    %File{}
    |> File.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a file.

  ## Examples

      iex> update_file(file, %{field: new_value})
      {:ok, %File{}}

      iex> update_file(file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_file(%File{} = file, attrs) do
    file
    |> File.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a File.

  ## Examples

      iex> delete_file(file)
      {:ok, %File{}}

      iex> delete_file(file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_file(%File{} = file) do
    Repo.delete(file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file changes.

  ## Examples

      iex> change_file(file)
      %Ecto.Changeset{source: %File{}}

  """
  def change_file(%File{} = file) do
    File.changeset(file, %{})
  end

  def get_files_by_messages(_model, ids) do
    Achatdemy.Messages.Message
    |> where([post], post.id in ^ids)
    |> preload(:files)
    |> Repo.all()
    |> Map.new(&{&1.id, &1.files})
  end

  def get_message_by_files(_model, ids) do
    Achatdemy.Messages.Message
    |> where([msg], msg.id in ^ids)
    |> Repo.all()
    |> Map.new(&{&1.id, &1})
  end

  def get_chat_by_messages(_model, ids) do
    Achatdemy.Chats.Chat
    |> where([chat], chat.id in ^ids)
    |> Repo.all()
    |> Map.new(&{&1.id, &1})
  end

  def get_user_by_messages(_model, ids) do
    Achatdemy.Users.User
    |> where([user], user.id in ^ids)
    |> Repo.all()
    |> Map.new(&{&1.id, &1})
  end
end
