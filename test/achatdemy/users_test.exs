defmodule Achatdemy.UsersTest do
  use Achatdemy.DataCase

  alias Achatdemy.Users

  describe "users" do
    alias Achatdemy.Users.User

    @valid_attrs %{email: "some email", password: "some password", username: "some username"}
    @update_attrs %{email: "some updated email", password: "some updated password", username: "some updated username"}
    @invalid_attrs %{email: nil, password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.password == "some password"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Users.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.password == "some updated password"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end

  describe "user_perms" do
    alias Achatdemy.Users.Perm

    @valid_attrs %{chmod: "some chmod"}
    @update_attrs %{chmod: "some updated chmod"}
    @invalid_attrs %{chmod: nil}

    def perm_fixture(attrs \\ %{}) do
      {:ok, perm} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_perm()

      perm
    end

    test "list_user_perms/0 returns all user_perms" do
      perm = perm_fixture()
      assert Users.list_user_perms() == [perm]
    end

    test "get_perm!/1 returns the perm with given id" do
      perm = perm_fixture()
      assert Users.get_perm!(perm.id) == perm
    end

    test "create_perm/1 with valid data creates a perm" do
      assert {:ok, %Perm{} = perm} = Users.create_perm(@valid_attrs)
      assert perm.chmod == "some chmod"
    end

    test "create_perm/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_perm(@invalid_attrs)
    end

    test "update_perm/2 with valid data updates the perm" do
      perm = perm_fixture()
      assert {:ok, %Perm{} = perm} = Users.update_perm(perm, @update_attrs)
      assert perm.chmod == "some updated chmod"
    end

    test "update_perm/2 with invalid data returns error changeset" do
      perm = perm_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_perm(perm, @invalid_attrs)
      assert perm == Users.get_perm!(perm.id)
    end

    test "delete_perm/1 deletes the perm" do
      perm = perm_fixture()
      assert {:ok, %Perm{}} = Users.delete_perm(perm)
      assert_raise Ecto.NoResultsError, fn -> Users.get_perm!(perm.id) end
    end

    test "change_perm/1 returns a perm changeset" do
      perm = perm_fixture()
      assert %Ecto.Changeset{} = Users.change_perm(perm)
    end
  end
end
