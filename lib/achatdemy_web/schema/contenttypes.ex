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
    field :user, :user do
      resolve fn perm, _, _ ->
        batch({Achatdemy.Users, :get_user_by_perms}, perm.user_id, fn batch_results ->
          {:ok, Map.get(batch_results, perm.user_id)}
        end)
      end
    end
    field :comm_id, non_null(:id)
    field :comm, :comm do
      resolve fn perm, _, _ ->
        batch({Achatdemy.Users, :get_comm_by_perms}, perm.comm_id, fn batch_results ->
          {:ok, Map.get(batch_results, perm.comm_id)}
        end)
      end
    end
    field :chmod, :integer
    field :perm_def, :perm_def do
      resolve fn perm, _, _ ->
        {:ok, Achatdemy.Perms.get_perm_map(perm.chmod)}
      end
    end
    field :raw_perm_def, :perm_def do
      resolve fn perm, _, _ ->
        {:ok, Achatdemy.Perms.get_raw_perm_map(perm.chmod)}
      end
    end
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :perm_def do
    field :create_msg,  :boolean
    field :mod_msg,     :boolean
    field :create_chat, :boolean
    field :mod_chat,    :boolean
    field :mod_comm,    :boolean
    field :admin,       :boolean
  end

  input_object :perm_def_input do
    field :create_msg,  :boolean
    field :mod_msg,     :boolean
    field :create_chat, :boolean
    field :mod_chat,    :boolean
    field :mod_comm,    :boolean
    field :admin,       :boolean
  end

  object :chat do
    field :id, non_null(:id)
    field :title, :string
    field :type, :integer
    field :user_id, :id
    field :user, :user do
      resolve fn chat, _, _ ->
        batch({Achatdemy.Chats, :get_user_by_chats}, chat.user_id, fn batch_results ->
          {:ok, Map.get(batch_results, chat.user_id)}
        end)
      end
    end
    field :comm_id, :id
    field :comm, :comm do
      resolve fn chat, _, _ ->
        batch({Achatdemy.Chats, :get_comm_by_chats}, chat.comm_id, fn batch_results ->
          {:ok, Map.get(batch_results, chat.comm_id)}
        end)
      end
    end
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
    field :chat, :chat do
      resolve fn message, _, _ ->
        batch({Achatdemy.Messages, :get_chat_by_messages}, message.chat_id, fn batch_results ->
          {:ok, Map.get(batch_results, message.chat_id)}
        end)
      end
    end
    field :user_id, :id
    field :user, :user do
      resolve fn message, _, _ ->
        batch({Achatdemy.Messages, :get_user_by_messages}, message.user_id, fn batch_results ->
          {:ok, Map.get(batch_results, message.user_id)}
        end)
      end
    end
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
    field :chat, :chat do
      resolve fn widget, _, _ ->
        batch({Achatdemy.Chats, :get_chat_by_widgets}, widget.chat_id, fn batch_results ->
          {:ok, Map.get(batch_results, widget.chat_id)}
        end)
      end
    end
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :file do
    field :id, non_null(:id)
    field :name, :string
    field :path, :string
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :message, :message do
      resolve fn file, _, _ ->
        batch({Achatdemy.Messages, :get_message_by_file}, file.message_id, fn batch_results ->
          {:ok, Map.get(batch_results, file.message_id)}
        end)
      end
    end
  end
end
