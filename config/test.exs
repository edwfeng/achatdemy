use Mix.Config

# Configure your database
config :achatdemy, Achatdemy.Repo,
  username: "postgres",
  password: "postgres",
  database: "achatdemy_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  port: 5433

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :achatdemy, AchatdemyWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
