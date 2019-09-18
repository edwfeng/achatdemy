defmodule AchatdemyWeb.Router do
  use AchatdemyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AchatdemyWeb do
    pipe_through :browser

    get "/otherthing", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", AchatdemyWeb do
  #   pipe_through :api
  # end
end
