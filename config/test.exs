use Mix.Config

config :cart, Cart.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "cart_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  timeout: 5000

config :cart,
  cart_node: node

config :logger, :console,
  level: :warn,
  format: "\n$date $time [$level] $message\n$metadata",
  metadata: [:error]
