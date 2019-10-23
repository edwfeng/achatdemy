defmodule AchatdemyWeb.UserController do
  use AchatdemyWeb, :controller

  alias Achatdemy.Users

  action_fallback AchatdemyWeb.FallbackController

  def create(conn, %{"username" => username, "password" => password}) do
    with params <- Users.user_login(username, password) do
      render(conn, "login.json", params: params)
    end
  end
end
