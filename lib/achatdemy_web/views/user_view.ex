defmodule AchatdemyWeb.UserView do
  use AchatdemyWeb, :view
  alias AchatdemyWeb.UserView

  def render("login.json", %{params: params}) do
    case params do
      {:ok, token} -> %{token: token}
      {_, error} -> %{error: error}
    end
  end
end
