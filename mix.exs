defmodule Downstream.MixProject do
  use Mix.Project

  def project do
    [
      app: :downstream,
      deps: deps(),
      docs: docs(),
      description: "An Elixir Client for Streaming Downloads",
      elixir: "~> 1.7",
      name: "Downstream",
      package: package(),
      preferred_cli_env: ["coveralls.html": :test],
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/mpiercy827/downstream",
      test_coverage: [tool: ExCoveralls],
      version: "1.0.0"
    ]
  end

  def application do
    [
      applications: [:httpoison]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: [:test]},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:httpoison, "~> 1.5.0"},
      {:mimic, "~> 0.2", only: :test}
    ]
  end

  defp docs do
    [
      main: "Downstream"
    ]
  end

  defp package do
    [
      files: ["lib", "LICENSE", "mix.exs", "README.md"],
      maintainers: ["Matt Piercy"],
      licenses: ["MIT"],
      links: %{
        "github" => "https://github.com/mpiercy827/downstream"
      }
    ]
  end
end
