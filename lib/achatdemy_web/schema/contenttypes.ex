defmodule AchatdemyWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation
  import_types Absinthe.Type.Custom

  object :user do
    field :id, non_null(:id)
    field :email, :string
    field :username, :string
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :perms, list_of(:perm) do
      resolve fn user, _, _ ->
        batch({Achatdemy.Users, :get_perms_by_users}, user.id, fn batch_results ->
          {:ok, Map.get(batch_results, user.id)}
        end)
      end
    end
    field :chats, list_of(:chat) do
      resolve fn user, _, _ ->
        batch({Achatdemy.Users, :get_chats_by_users}, user.id, fn batch_results ->
          {:ok, Map.get(batch_results, user.id)}
        end)
      end
    end
    field :messages, list_of(:message) do
      resolve fn user, _, _ ->
        batch({Achatdemy.Users, :get_messages_by_users}, user.id, fn batch_results ->
          {:ok, Map.get(batch_results, user.id)}
        end)
      end
    end
  end

  object :comm do
    field :id, non_null(:id)
    field :name, :string
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :perms, list_of(:perm) do
      resolve fn comm, _, _ ->
        batch({Achatdemy.Comms, :get_perms_by_comms}, comm.id, fn batch_results ->
          {:ok, Map.get(batch_results, comm.id)}
        end)
      end
    end
    field :chats, list_of(:chat) do
      resolve fn comm, _, _ ->
        batch({Achatdemy.Comms, :get_chats_by_comms}, comm.id, fn batch_results ->
          {:ok, Map.get(batch_results, comm.id)}
        end)
      end
    end
  end

  object :perm do
    field :user_id, non_null(:id)
    field :comm_id, non_null(:id)
    field :chmod, :integer
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :chat do
    field :id, non_null(:id)
    field :title, :string
    field :type, :integer
    field :user_id, :id
    field :comm_id, :id
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :messages, list_of(:message) do
      resolve fn chat, _, _ ->
        batch({Achatdemy.Chats, :get_messages_by_chats}, chat.id, fn batch_results ->
          {:ok, Map.get(batch_results, chat.id)}
        end)
      end
    end
    field :widgets, list_of(:widget) do
      resolve fn chat, _, _ ->
        batch({Achatdemy.Chats, :get_widgets_by_chats}, chat.id, fn batch_results ->
          {:ok, Map.get(batch_results, chat.id)}
        end)
      end
    end
  end

  object :message do
    field :id, non_null(:id)
    field :msg, :string
    field :chat_id, :id
    field :user_id, :id
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :files, list_of(:file) do
      resolve fn message, _, _ ->
        batch({Achatdemy.Messages, :get_files_by_messages}, message.id, fn batch_results ->
          {:ok, Map.get(batch_results, message.id)}
        end)
      end
    end
  end

  object :widget do
    field :id, non_null(:id)
    field :desc, :string
    field :uri, :string
    field :chat_id, :id
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :file do
    field :id, non_null(:id)
    field :name, :string
    field :path, :string
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :messages, list_of(:message) do
      resolve fn file, _, _ ->
        batch({Achatdemy.Messages, :get_messages_by_files}, file.id, fn batch_results ->
          {:ok, Map.get(batch_results, file.id)}
        end)
      end
    end
  end
end
