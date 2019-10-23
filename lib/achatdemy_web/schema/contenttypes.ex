defmodule AchatdemyWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation
  import_types Absinthe.Type.Custom

  object :user do
    field :id, non_null(:id)
    field :email, :string
    field :username, :string
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :comm do
    field :id, non_null(:id)
    field :name, :string
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
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
  end

  object :message do
    field :id, non_null(:id)
    field :msg, :string
    field :chat_id, :id
    field :user_id, :id
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
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
  end
end
