defmodule AchatdemyWeb.Schema do
  use Absinthe.Schema
  import_types AchatdemyWeb.Schema.ContentTypes

  query do
    @desc "Get a list of users"
    field :users, list_of(:user) do
      resolve &AchatdemyWeb.Resolvers.Users.list_users/3
    end

    @desc "Get a user by its id"
    field :user, :user do
      arg :id, non_null(:id)
      resolve &AchatdemyWeb.Resolvers.Users.list_user/3
    end
  end
end
