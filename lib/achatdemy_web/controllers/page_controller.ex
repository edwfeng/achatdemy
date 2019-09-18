defmodule AchatdemyWeb.PageController do
  use AchatdemyWeb, :controller

  def index(conn, _params) do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> Plug.Conn.send_file(200, Path.expand(Path.join(__ENV__.file, "../../../../priv/static/index.html")))
  end

  def oldindex(conn, _params) do
    render(conn, "index.html")
  end
end
