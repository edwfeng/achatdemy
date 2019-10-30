defmodule AchatdemyWeb.Schema do
  use Absinthe.Schema
  import_types AchatdemyWeb.Schema.ContentTypes

  query do
    @desc "Get a list of users"
    field :users, list_of(:user) do
      resolve &AchatdemyWeb.Resolvers.Users.list_users/3
    end

    @desc "Get a user"
    field :user, :user do
      arg :id, :id
      arg :username, :string
      arg :email, :string
      resolve &AchatdemyWeb.Resolvers.Users.list_user/3
    end

    @desc "Get a list of communities"
    field :comms, list_of(:comm) do
      resolve &AchatdemyWeb.Resolvers.Comms.list_comms/3
    end

    @desc "Get a community"
    field :comm, :comm do
      arg :id, :id
      arg :name, :string
      resolve &AchatdemyWeb.Resolvers.Comms.list_comm/3
    end

    @desc "Get a list of perms"
    field :perms, list_of(:perm) do
      arg :user_id, :id
      arg :comm_id, :id
      resolve &AchatdemyWeb.Resolvers.Users.list_perms/3
    end

    @desc "Get a list of chats"
    field :chats, list_of(:chat) do
      arg :comm_id, :id
      arg :user_id, :id
      arg :type, :integer
      resolve &AchatdemyWeb.Resolvers.Chats.list_chats/3
    end

    @desc "Get a chat"
    field :chat, :chat do
      arg :id, :id
      resolve &AchatdemyWeb.Resolvers.Chats.list_chat/3
    end

    @desc "Get a list of messages"
    field :messages, list_of(:message) do
      arg :chat_id, :id
      arg :user_id, :id
      resolve &AchatdemyWeb.Resolvers.Messages.list_messages/3
    end

    @desc "Get a message"
    field :message, :message do
      arg :id, :id
      resolve &AchatdemyWeb.Resolvers.Messages.list_message/3
    end

    @desc "Get a list of widgets"
    field :widgets, list_of(:widget) do
      arg :chat_id, :id
      resolve &AchatdemyWeb.Resolvers.Chats.list_widgets/3
    end

    @desc "Get a widget"
    field :widget, :widget do
      arg :id, :id
      resolve &AchatdemyWeb.Resolvers.Chats.list_widget/3
    end

    @desc "Get a list of files"
    field :files, list_of(:file) do
      resolve &AchatdemyWeb.Resolvers.Messages.list_files/3
    end

    @desc "Get a file"
    field :file, :file do
      arg :id, :id
      resolve &AchatdemyWeb.Resolvers.Messages.list_file/3
    end
  end
end
