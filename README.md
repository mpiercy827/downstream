# Downstream


[![Travis](https://img.shields.io/travis/mpiercy827/downstream.svg)](https://travis-ci.org/mpiercy827/downstream)
[![Hex.pm](https://img.shields.io/hexpm/v/downstream.svg)](https://hex.pm/packages/downstream/)


Downstream is a library for downloading files via HTTPoison response streaming.

## Installation

To use Downstream in your project, include it in your `mix.exs` file dependencies
and applications:

```elixir
def application do
  [applications: [:downstream]]
end

def deps do
  [
    {:downstream, "~> 0.1.0"}
  ]
end
```

## Usage

Using `Downstream` is simple. Just pass it a URL and an IO device:

```elixir
file = File.open!("index.html", [:write])

{:ok, device} = Downstream.get("https://google.com", file)
```

## Current Features

- Stream downloads via HTTP GET requests
- Stream downloads via HTTP POST requests
- Configurable request timeouts

## Roadmap

- [ ] Add support for callbacks (i.e. header handler, status handler, etc.)
