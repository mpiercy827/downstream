defmodule Downstream.MixProject do
  use Mix.Project

  @source_url "https://github.com/mpiercy827/downstream"
  @version "1.1.0"

  def project do
    [
      app: :downstream,
      deps: deps(),
      docs: docs(),
      elixir: "~> 1.7",
      name: "Downstream",
      package: package(),
      preferred_cli_env: ["coveralls.html": :test],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: @version
    ]
  end

  def application do
    [
      applications: [:httpoison]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: [:test]},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:httpoison, "~> 1.5"},
      {:mimic, "~> 0.2", only: :test}
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [],
        "CONTRIBUTING.md": [title: "Contributing"],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end

  defp package do
    [
      description: "An Elixir Client for Streaming Downloads",
      files: ["lib", "LICENSE.md", "mix.exs", "README.md"],
      maintainers: ["Matt Piercy"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end
end
