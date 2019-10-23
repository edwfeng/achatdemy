use Mix.Config

# Configure your database
config :achatdemy, Achatdemy.Repo,
  username: "postgres",
  password: "postgres",
  database: "achatdemy_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  port: 5433

config :achatdemy, Achatdemy.Guardian,
  issuer: "achatdemy_test",
  secret_key: "achatdemy_test"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :achatdemy, AchatdemyWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

if File.exists?(Path.expand(Path.join(__ENV__.file, "../test.secret.exs"))) do
  import_config("test.secret.exs")
end
