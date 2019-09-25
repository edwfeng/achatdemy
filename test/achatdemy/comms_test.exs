defmodule Achatdemy.CommsTest do
  use Achatdemy.DataCase

  alias Achatdemy.Comms

  describe "comms" do
    alias Achatdemy.Comms.Comm

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def comm_fixture(attrs \\ %{}) do
      {:ok, comm} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Comms.create_comm()

      comm
    end

    test "list_comms/0 returns all comms" do
      comm = comm_fixture()
      assert Comms.list_comms() == [comm]
    end

    test "get_comm!/1 returns the comm with given id" do
      comm = comm_fixture()
      assert Comms.get_comm!(comm.id) == comm
    end

    test "create_comm/1 with valid data creates a comm" do
      assert {:ok, %Comm{} = comm} = Comms.create_comm(@valid_attrs)
      assert comm.name == "some name"
    end

    test "create_comm/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comms.create_comm(@invalid_attrs)
    end

    test "update_comm/2 with valid data updates the comm" do
      comm = comm_fixture()
      assert {:ok, %Comm{} = comm} = Comms.update_comm(comm, @update_attrs)
      assert comm.name == "some updated name"
    end

    test "update_comm/2 with invalid data returns error changeset" do
      comm = comm_fixture()
      assert {:error, %Ecto.Changeset{}} = Comms.update_comm(comm, @invalid_attrs)
      assert comm == Comms.get_comm!(comm.id)
    end

    test "delete_comm/1 deletes the comm" do
      comm = comm_fixture()
      assert {:ok, %Comm{}} = Comms.delete_comm(comm)
      assert_raise Ecto.NoResultsError, fn -> Comms.get_comm!(comm.id) end
    end

    test "change_comm/1 returns a comm changeset" do
      comm = comm_fixture()
      assert %Ecto.Changeset{} = Comms.change_comm(comm)
    end
  end
end
