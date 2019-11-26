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
    plug AchatdemyWeb.Auth
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    resources "/auth", AchatdemyWeb.UserController, only: [:create]

    if Mix.env == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: AchatdemyWeb.Schema,
        socket: AchatdemyWeb.UserSocket,
        interface: :simple
    end

    forward "/", Absinthe.Plug,
      schema: AchatdemyWeb.Schema
  end

  scope "/", AchatdemyWeb do
    pipe_through :browser

    get "/old", PageController, :oldindex
    get "/*path", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", AchatdemyWeb do
  #   pipe_through :api
  # end
end
