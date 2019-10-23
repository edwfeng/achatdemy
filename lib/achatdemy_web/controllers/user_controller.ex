defmodule AchatdemyWeb.UserController do
  use AchatdemyWeb, :controller

  alias Achatdemy.Users

  action_fallback AchatdemyWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with params <- Users.user_login(user_params) do
      render(conn, "login.json", params: params)
    end
  end
end
