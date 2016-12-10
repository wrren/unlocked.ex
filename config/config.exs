# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :unlocked,
  ecto_repos: [Unlocked.Repo]

# Configures the endpoint
config :unlocked, Unlocked.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aDE3lB+tK1nZNJpEH4QcTwt93ylD2s4xr3lS8CAkGa79gpi/7YgNx32iUhYPuKiV",
  render_errors: [view: Unlocked.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Unlocked.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [
      default_scope: "email profile",
      hd: "riotgames.com",
      request_url: "/score/auth/google/",
      callback_url: "/score/result/google/callback"
    ]},
    google: {Ueberauth.Strategy.Google, [
      default_scope: "email profile",
      hd: "riotgames.com",
      request_url: "/auth/google/",
      callback_url: "/auth/google/callback"
    ]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
