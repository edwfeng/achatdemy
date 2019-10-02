defmodule AchatdemyWeb.Router do
  use AchatdemyWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end
  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AchatdemyWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/old", PageController, :oldindex

  end

  # Other scopes may use custom stacks.
  # scope "/api", AchatdemyWeb do
  #   pipe_through :api
  # end
end
