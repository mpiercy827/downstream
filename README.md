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

Using `Downstream` is simple. First, start it your application:

```elixir
Downstream.start()
```

Then, just pass it a URL and an IO device:

```elixir
iex(1)> file = File.open!("index.html", [:write])
#PID<0.84.0>
iex(2)> Downstream.get("https://www.google.com", file)
{:ok,
 %Downstream.Response{
   device: #PID<0.84.0>,
   headers: [
     {"Date", "Sat, 09 Feb 2019 14:25:34 GMT"},
     {"Expires", "-1"},
     {"Cache-Control", "private, max-age=0"},
     {"Content-Type", "text/html; charset=ISO-8859-1"},
     ...
     {"Server", "gws"},
     {"X-XSS-Protection", "1; mode=block"},
     {"X-Frame-Options", "SAMEORIGIN"},
     {"Accept-Ranges", "none"},
     {"Vary", "Accept-Encoding"},
     {"Transfer-Encoding", "chunked"}
   ],
   status_code: 200
 }}
iex(3)> File.close(file)
:ok
```

Bang methods are also provided:

```elixir
iex(1)> file = File.open!("index.html", [:write])
#PID<0.84.0>
iex(2)> Downstream.get("https://www.google.com", file)
%Downstream.Response{
  device: #PID<0.84.0>,
  headers: [
    {"Date", "Sat, 09 Feb 2019 14:25:34 GMT"},
    {"Expires", "-1"},
    {"Cache-Control", "private, max-age=0"},
    {"Content-Type", "text/html; charset=ISO-8859-1"},
    ...
    {"Server", "gws"},
    {"X-XSS-Protection", "1; mode=block"},
    {"X-Frame-Options", "SAMEORIGIN"},
    {"Accept-Ranges", "none"},
    {"Vary", "Accept-Encoding"},
    {"Transfer-Encoding", "chunked"}
  ],
  status_code: 200
}}
iex(3)> File.close(file)
:ok
```

`Downstream` currently supports streaming downloads via the `get/2`, `post/2`, `get!/2` and `post!/2` methods. For all non-200 status codes, an error is returned.

```elixir
iex(1)> file = File.open!("index.html", [:write])
#PID<0.84.0>
iex(2)> Downstream.get("https://www.google.com/notfound", file)
{:error,
 %Downstream.Error{
   device: #PID<0.84.0>,
   reason: :invalid_status_code,
   status_code: 404
 }}
iex(3)> File.close(file)
:ok
```
## Current Features

- Stream downloads via HTTP GET requests
- Stream downloads via HTTP POST requests
- Configurable request timeouts

## Development

### Running Tests

To run the tests, run one of the following commands:

```bash
$ mix test           # Run test suite without code coverage analysis
$ mix coveralls.html # Run test suite with code coverage analysis
```

### Linter

To run the linter, run the following command:

```bash
$ mix credo
```

### Type Analysis

To run a static type analysis with Dialyzer, run the following command:

```bash
$ mix dialyzer
```

### Formatting

This project uses the default configuration for the Elixir formatter. To format
any changes, run the following command:

```bash
$ mix format
```
