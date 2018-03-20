defmodule DownstreamTest do
  use ExUnit.Case
  doctest Downstream

  @success_url "https://httpstat.us/200"
  @error_url "https://httpstat.us/404"

  describe "get/3" do
    setup _context do
      {:ok, pid} = StringIO.open("get test")

      [io_device: pid]
    end

    test "successfully downloads a file with a get request", context do
      {:ok, io_device} = Downstream.get(@success_url, context.io_device)

      assert io_device == context.io_device
      assert StringIO.flush(io_device) == "200 OK"
    end

    test "returns an error for an unsuccessful download", context do
      assert Downstream.get(@error_url, context.io_device) == {:error, "status code 404"}
    end

    test "accepts a configurable timeout", context do
      url = "#{@success_url}?sleep=5000"

      assert Downstream.get(url, context.io_device, timeout: 1_000) == {:error, "request timeout"}
    end
  end

  describe "get!/3" do
    setup _context do
      {:ok, pid} = StringIO.open("get! test")

      [io_device: pid]
    end

    test "successfully downloads a file with a get request", context do
      io_device = Downstream.get!(@success_url, context.io_device)

      assert io_device == context.io_device
      assert StringIO.flush(io_device) == "200 OK"
    end

    test "raises an error for an unsuccessful download", context do
      assert_raise RuntimeError, "status code 404", fn ->
        Downstream.get!(@error_url, context.io_device)
      end
    end
  end

  describe "post/4" do
    setup _context do
      {:ok, pid} = StringIO.open("post test")

      [io_device: pid]
    end

    test "successfully downloads a file with a post request", context do
      {:ok, io_device} = Downstream.post(@success_url, context.io_device)

      assert io_device == context.io_device
      assert StringIO.flush(io_device) == "200 OK"
    end

    test "returns an error for an unsuccessful download", context do
      assert Downstream.post(@error_url, context.io_device) == {:error, "status code 404"}
    end

    test "accepts a configurable timeout", context do
      url = "#{@success_url}?sleep=5000"

      assert Downstream.post(url, context.io_device, "", timeout: 1_000) ==
               {:error, "request timeout"}
    end
  end

  describe "post!/4" do
    setup _context do
      {:ok, pid} = StringIO.open("post! test")

      [io_device: pid]
    end

    test "successfully downloads a file with a post request", context do
      io_device = Downstream.post!(@success_url, context.io_device)

      assert io_device == context.io_device
      assert StringIO.flush(io_device) == "200 OK"
    end

    test "raises an error for an unsuccessful download", context do
      assert_raise RuntimeError, "status code 404", fn ->
        Downstream.post!(@error_url, context.io_device)
      end
    end
  end
end
