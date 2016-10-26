defmodule Cart.Mixfile do
  use Mix.Project

  def project do
    [app: :cart,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [mod: {Cart, []},
     applications: applications(Mix.env)]
  end

  defp applications(:dev), do: applications(:all)
  defp applications(:test), do: applications(:all)
  defp applications(_all) do
    [
      :ecto,
      :ex_utils,
      :poison,
      :postgrex,
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  defp description do
    "Simple generic shopping cart application."
  end

  defp deps do
    [
     {:ecto, "~> 2.1.0-rc.2"},
     {:ex_utils, git: "ssh://git@stash.wd.faber:7999/lib/ex_utils.git"},
     {:poison, "~> 2.2"},
     {:postgrex, "~> 0.12.0"},
    ]
  end

  defp package do
    [maintainers: ["Farhad Taebi", "Matthias Lindhorst", "Andreas Graeff"],
     licenses: ["Unlicense"],
     links: %{"GitHub" => "https://github.com/faber-lotto/cart"},
     files: ~w(mix.exs README.md test lib config priv)]
  end
end
