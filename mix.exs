defmodule Downstream.MixProject do
  use Mix.Project

  def project do
    [
      app: :downstream,
      deps: deps(),
      docs: docs(),
      elixir: "~> 1.6",
      name: "Downstream",
      preferred_cli_env: ["coveralls.html": :test],
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/mpiercy827/downstream",
      test_coverage: [tool: ExCoveralls],
      version: "0.1.0"
    ]
  end

  def application do
    [
      applications: [:httpoison, :logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.8.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.8", only: [:test]},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:httpoison, "~> 1.0.0"}
    ]
  end

  defp docs do
    [
      main: "Downstream"
    ]
  end
end
