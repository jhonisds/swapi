import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :swapi, Swapi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  database: "swapi_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :swapi, SwapiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "o0dlIAhzJf9uv4cGVwTmjSkmQRBn2DOIm3XvN5M8JrU+8+qdyhhZrL8nPD98GpR/",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configuration for the {LoggerFileBackend, :info_log}
config :logger, :info_log, path: "logs/test/info.log"

# Configuration for the {LoggerFileBackend, :error_log}
config :logger, :error_log, path: "logs/test/error.log"

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
