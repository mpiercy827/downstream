defmodule DownstreamTest do
  use ExUnit.Case
  doctest Downstream

  @success """
  {
    "statusCode" : 200,
    "description": "OK"
  }\
  """

  describe "get/4" do
    setup _context do
      {:ok, pid} = StringIO.open("get test")

      [io_device: pid]
    end

    test "successfully downloads a file with a get request", context do
      {:ok, io_device} = Downstream.get("https://mock.codes/200", context.io_device)

      assert io_device == context.io_device
      assert StringIO.flush(io_device) == @success
    end

    test "returns an error for an unsuccessful download", context do
      assert Downstream.get("https://mock.codes/404", context.io_device) ==
               {:error, "status code 404"}
    end
  end

  describe "get!/4" do
    setup _context do
      {:ok, pid} = StringIO.open("get! test")

      [io_device: pid]
    end

    test "successfully downloads a file with a get request", context do
      io_device = Downstream.get!("https://mock.codes/200", context.io_device)

      assert io_device == context.io_device
      assert StringIO.flush(io_device) == @success
    end

    test "raises an error for an unsuccessful download", context do
      assert_raise RuntimeError, "status code 404", fn ->
        Downstream.get!("https://mock.codes/404", context.io_device)
      end
    end
  end
end
