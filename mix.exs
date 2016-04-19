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
     [:postgrex, :ecto]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  defp description do
    "Simple generic shopping cart application."
  end

  defp deps do
    [{:postgrex, "~> 0.11.1"},
     {:poison, "~> 2.1.0"},
     {:ecto, "~> 2.0-beta"}]
  end

  defp package do
    [maintainers: ["Farhad Taebi", "Matthias Lindhorst"],
     licenses: ["Unlicense"],
     links: %{"GitHub" => "https://github.com/faber-lotto/cart"},
     files: ~w(mix.exs README.md test lib config priv)]
  end
end
