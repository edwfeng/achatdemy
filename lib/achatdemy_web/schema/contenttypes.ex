defmodule AchatdemyWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation

  object :user do
    field :id, non_null(:id)
    field :email, non_null(:string)
    field :password, non_null(:string)
    field :username, non_null(:string)
  end

  object :comm do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end
end
