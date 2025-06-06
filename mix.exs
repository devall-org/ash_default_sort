defmodule AshDefaultSort.MixProject do
  use Mix.Project

  def project do
    [
      app: :ash_default_sort,
      version: "0.2.0",
      elixir: "~> 1.17",
      consolidate_protocols: Mix.env() not in [:dev, :test],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description:
        "Configure a default sort to apply when a read action or a has_many relationship has no sort.",
      package: package(),
      source_url: "https://github.com/devall-org/ash_default_sort",
      homepage_url: "https://github.com/devall-org/ash_default_sort",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ash, ">= 0.0.0"},
      {:spark, ">= 0.0.0"},
      {:sourceror, ">= 0.0.0", only: [:dev, :test], optional: true},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: "ash_default_sort",
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/devall-org/ash_default_sort"
      }
    ]
  end
end
