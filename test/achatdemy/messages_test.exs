defmodule Achatdemy.MessagesTest do
  use Achatdemy.DataCase

  alias Achatdemy.Messages

  describe "files" do
    alias Achatdemy.Messages.File

    @valid_attrs %{name: "some name", path: "some path"}
    @update_attrs %{name: "some updated name", path: "some updated path"}
    @invalid_attrs %{name: nil, path: nil}

    def file_fixture(attrs \\ %{}) do
      {:ok, file} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messages.create_file()

      file
    end

    test "list_files/0 returns all files" do
      file = file_fixture()
      assert Messages.list_files() == [file]
    end

    test "get_file!/1 returns the file with given id" do
      file = file_fixture()
      assert Messages.get_file!(file.id) == file
    end

    test "create_file/1 with valid data creates a file" do
      assert {:ok, %File{} = file} = Messages.create_file(@valid_attrs)
      assert file.name == "some name"
      assert file.path == "some path"
    end

    test "create_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_file(@invalid_attrs)
    end

    test "update_file/2 with valid data updates the file" do
      file = file_fixture()
      assert {:ok, %File{} = file} = Messages.update_file(file, @update_attrs)
      assert file.name == "some updated name"
      assert file.path == "some updated path"
    end

    test "update_file/2 with invalid data returns error changeset" do
      file = file_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_file(file, @invalid_attrs)
      assert file == Messages.get_file!(file.id)
    end

    test "delete_file/1 deletes the file" do
      file = file_fixture()
      assert {:ok, %File{}} = Messages.delete_file(file)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_file!(file.id) end
    end

    test "change_file/1 returns a file changeset" do
      file = file_fixture()
      assert %Ecto.Changeset{} = Messages.change_file(file)
    end
  end
end
