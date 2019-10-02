defmodule AchatdemyWeb.Resolvers.Users do
  alias Achatdemy.Users

  def list_users(_, _, _) do
    {:ok, Users.list_users()}
  end

  def list_user(_, %{id: id}, _) do
    {:ok, Users.get_user!(id)}
  end
end
