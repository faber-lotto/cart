use Mix.Config

config :cart,
  ecto_repos: [Cart.Repo]

import_config "#{Mix.env}.exs"
