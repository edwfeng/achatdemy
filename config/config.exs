# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :achatdemy,
  ecto_repos: [Achatdemy.Repo]

# Configures the endpoint
config :achatdemy, AchatdemyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "geReKjfAjFMxciylrKdayLX1R0ZbPPP3gyW159b1tIFITw5pElMXVcJCRo43f2bK",
  render_errors: [view: AchatdemyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Achatdemy.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
