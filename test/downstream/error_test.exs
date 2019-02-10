defmodule Downstream.ErrorTest do
  use ExUnit.Case

  alias Downstream.Error

  describe "message/1" do
    test "returns the reason" do
      assert Error.message(%Error{reason: :timeout}) == ":timeout"
    end
  end
end
