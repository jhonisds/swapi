# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :swapi,
  namespace: SwapiWeb,
  ecto_repos: [Swapi.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :swapi, SwapiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: SwapiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Swapi.PubSub,
  live_view: [signing_salt: "5K2ftj+n"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures LoggerFileBackend
config :logger,
  backends: [
    :console,
    {LoggerFileBackend, :info_log},
    {LoggerFileBackend, :error_log}
  ]

# Configuration for the {LoggerFileBackend, :info_log}
config :logger, :info_log,
  path: "logs/info.log",
  level: :info,
  metadata: [:module, :function_name]

# Configuration for the {LoggerFileBackend, :error_log}
config :logger, :error_log,
  path: "logs/error.log",
  level: :error,
  metadata: [:module, :function_name]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
