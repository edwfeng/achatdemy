# TODO: Actually test index page

defmodule AchatdemyWeb.PageControllerTest do
  use AchatdemyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    # assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
