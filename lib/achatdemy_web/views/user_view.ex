defmodule AchatdemyWeb.UserView do
  use AchatdemyWeb, :view
  alias AchatdemyWeb.UserView

  def render("login.json", %{params: params}) do
    case params do
      {:ok, token, claims} -> %{token: token, claims: claims}
      {_, error} -> %{error: error}
    end
  end
end
