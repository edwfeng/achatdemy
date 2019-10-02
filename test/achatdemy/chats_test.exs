defmodule Achatdemy.ChatsTest do
  use Achatdemy.DataCase

  alias Achatdemy.Chats

  describe "chats" do
    alias Achatdemy.Chats.Chat

    @valid_attrs %{title: "some title", type: 42}
    @update_attrs %{title: "some updated title", type: 43}
    @invalid_attrs %{title: nil, type: nil}

    def chat_fixture(attrs \\ %{}) do
      {:ok, chat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chats.create_chat()

      chat
    end

    test "list_chats/0 returns all chats" do
      chat = chat_fixture()
      assert Chats.list_chats() == [chat]
    end

    test "get_chat!/1 returns the chat with given id" do
      chat = chat_fixture()
      assert Chats.get_chat!(chat.id) == chat
    end

    test "create_chat/1 with valid data creates a chat" do
      assert {:ok, %Chat{} = chat} = Chats.create_chat(@valid_attrs)
      assert chat.title == "some title"
      assert chat.type == 42
    end

    test "create_chat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chats.create_chat(@invalid_attrs)
    end

    test "update_chat/2 with valid data updates the chat" do
      chat = chat_fixture()
      assert {:ok, %Chat{} = chat} = Chats.update_chat(chat, @update_attrs)
      assert chat.title == "some updated title"
      assert chat.type == 43
    end

    test "update_chat/2 with invalid data returns error changeset" do
      chat = chat_fixture()
      assert {:error, %Ecto.Changeset{}} = Chats.update_chat(chat, @invalid_attrs)
      assert chat == Chats.get_chat!(chat.id)
    end

    test "delete_chat/1 deletes the chat" do
      chat = chat_fixture()
      assert {:ok, %Chat{}} = Chats.delete_chat(chat)
      assert_raise Ecto.NoResultsError, fn -> Chats.get_chat!(chat.id) end
    end

    test "change_chat/1 returns a chat changeset" do
      chat = chat_fixture()
      assert %Ecto.Changeset{} = Chats.change_chat(chat)
    end
  end

  describe "widgets" do
    alias Achatdemy.Chats.Widget

    @valid_attrs %{desc: "some desc", uri: "some uri"}
    @update_attrs %{desc: "some updated desc", uri: "some updated uri"}
    @invalid_attrs %{desc: nil, uri: nil}

    def widget_fixture(attrs \\ %{}) do
      {:ok, widget} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chats.create_widget()

      widget
    end

    test "list_widgets/0 returns all widgets" do
      widget = widget_fixture()
      assert Chats.list_widgets() == [widget]
    end

    test "get_widget!/1 returns the widget with given id" do
      widget = widget_fixture()
      assert Chats.get_widget!(widget.id) == widget
    end

    test "create_widget/1 with valid data creates a widget" do
      assert {:ok, %Widget{} = widget} = Chats.create_widget(@valid_attrs)
      assert widget.desc == "some desc"
      assert widget.uri == "some uri"
    end

    test "create_widget/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chats.create_widget(@invalid_attrs)
    end

    test "update_widget/2 with valid data updates the widget" do
      widget = widget_fixture()
      assert {:ok, %Widget{} = widget} = Chats.update_widget(widget, @update_attrs)
      assert widget.desc == "some updated desc"
      assert widget.uri == "some updated uri"
    end

    test "update_widget/2 with invalid data returns error changeset" do
      widget = widget_fixture()
      assert {:error, %Ecto.Changeset{}} = Chats.update_widget(widget, @invalid_attrs)
      assert widget == Chats.get_widget!(widget.id)
    end

    test "delete_widget/1 deletes the widget" do
      widget = widget_fixture()
      assert {:ok, %Widget{}} = Chats.delete_widget(widget)
      assert_raise Ecto.NoResultsError, fn -> Chats.get_widget!(widget.id) end
    end

    test "change_widget/1 returns a widget changeset" do
      widget = widget_fixture()
      assert %Ecto.Changeset{} = Chats.change_widget(widget)
    end
  end
end
