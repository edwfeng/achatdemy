defmodule Achatdemy.Comms do
  @moduledoc """
  The Comms context.
  """

  import Ecto.Query, warn: false
  alias Achatdemy.Repo

  alias Achatdemy.Comms.Comm

  @doc """
  Returns the list of comms.

  ## Examples

      iex> list_comms()
      [%Comm{}, ...]

  """
  def list_comms do
    Repo.all(Comm)
  end

  @doc """
  Gets a single comm.

  Raises `Ecto.NoResultsError` if the Comm does not exist.

  ## Examples

      iex> get_comm!(123)
      %Comm{}

      iex> get_comm!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comm!(id), do: Repo.get!(Comm, id)

  def get_comms(args \\ %{}) when is_map(args) do
    get_comm_query(args)
    |> Repo.all
  end

  def get_comm(args \\ %{}) when is_map(args) do
    get_comm_query(args)
    |> Repo.one
  end

  defp get_comm_query(args) when is_map(args) do
    query = Comm

    args
    |> Enum.reduce(query, fn {arg, val}, query ->
      binding = [{arg, val}]
      query
      |> where(^binding)
    end)
  end

  def get_comms_fuzzy(name, threshold) do
    from(c in Comm,
      where: fragment("SIMILARITY(?, ?) > ?", c.name, ^name, ^threshold),
      order_by: fragment("SIMILARITY(?, ?) DESC", c.name, ^name))
    |> Repo.all
  end

  @doc """
  Creates a comm.

  ## Examples

      iex> create_comm(%{field: value})
      {:ok, %Comm{}}

      iex> create_comm(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comm(attrs \\ %{}) do
    %Comm{}
    |> Comm.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comm.

  ## Examples

      iex> update_comm(comm, %{field: new_value})
      {:ok, %Comm{}}

      iex> update_comm(comm, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comm(%Comm{} = comm, attrs) do
    comm
    |> Comm.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comm.

  ## Examples

      iex> delete_comm(comm)
      {:ok, %Comm{}}

      iex> delete_comm(comm)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comm(%Comm{} = comm) do
    Repo.delete(comm)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comm changes.

  ## Examples

      iex> change_comm(comm)
      %Ecto.Changeset{source: %Comm{}}

  """
  def change_comm(%Comm{} = comm) do
    Comm.changeset(comm, %{})
  end

  def get_perms_by_comms(_model, ids) do
    Achatdemy.Users.Perm
    |> where([perm], perm.comm_id in ^ids)
    |> Repo.all()
    |> Enum.group_by(&(&1.comm_id))
  end

  def get_chats_by_comms(_model, ids) do
    Achatdemy.Chats.Chat
    |> where([chat], chat.comm_id in ^ids)
    |> Repo.all()
    |> Enum.group_by(&(&1.comm_id))
  end
end
