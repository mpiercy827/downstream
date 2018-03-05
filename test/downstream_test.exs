defmodule DownstreamTest do
  use ExUnit.Case
  doctest Downstream

  test "greets the world" do
    assert Downstream.hello() == :world
  end
end
