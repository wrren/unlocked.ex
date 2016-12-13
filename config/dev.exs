use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :unlocked, Unlocked.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [
      default_scope: "email profile",
      hd: "riotgames.com",
      request_url: "/score/auth/google/",
      callback_url: "http://unlocked.local.com/score/result/google/callback"
    ]},
    google: {Ueberauth.Strategy.Google, [
      default_scope: "email profile",
      hd: "riotgames.com"
    ]}
  ]

# Configures the endpoint
config :unlocked, Unlocked.Endpoint,
  url: [host: "unlocked.local.com"],
  secret_key_base: "aDE3lB+tK1nZNJpEH4QcTwt93ylD2s4xr3lS8CAkGa79gpi/7YgNx32iUhYPuKiV",
  render_errors: [view: Unlocked.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Unlocked.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Watch static and templates for browser reloading.
config :unlocked, Unlocked.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :unlocked, Unlocked.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "unlocked",
  password: "unlocked",
  database: "unlocked_dev",
  hostname: "localhost",
  pool_size: 10

# Time, in seconds, allowed between successive scores
config :unlocked, 
  :score_interval, 20