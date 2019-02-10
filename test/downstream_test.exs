defmodule DownstreamTest do
  use ExUnit.Case, async: true
  doctest Downstream

  @tag timeout: 10_000

  alias Downstream.Error

  @get_success_url "https://s3-us-west-2.amazonaws.com/downstream-test/downstream.txt"
  @post_success_url "https://httpstat.us/200"
  @error_url "https://s3-us-west-2.amazonaws.com/downstream-test/notfound.txt"

  describe "get/3" do
    setup _context do
      {:ok, pid} = StringIO.open("get test")

      [io_device: pid]
    end

    test "successfully downloads a file with a get request", context do
      {:ok, response} = Downstream.get(@get_success_url, context.io_device)

      assert response.device == context.io_device
      assert response.status_code == 200
      assert is_binary(StringIO.flush(response.device))
    end

    test "returns an error for an unsuccessful download", context do
      {:error, response} = Downstream.get(@error_url, context.io_device)

      assert response.status_code == 403
    end

    test "accepts a configurable timeout", context do
      {:error, error} = Downstream.get(@get_success_url, context.io_device, timeout: 0)

      assert error.reason == :timeout
    end
  end

  describe "get!/3" do
    setup _context do
      {:ok, pid} = StringIO.open("get! test")

      [io_device: pid]
    end

    test "successfully downloads a file with a get request", context do
      response = Downstream.get!(@get_success_url, context.io_device)

      assert response.device == context.io_device
      assert response.status_code == 200
      assert is_binary(StringIO.flush(response.device))
    end

    test "raises an error for an unsuccessful download", context do
      assert_raise Error, fn ->
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
      {:ok, response} = Downstream.post(@post_success_url, context.io_device)

      assert response.device == context.io_device
      assert response.status_code == 200
      assert is_binary(StringIO.flush(response.device))
    end

    test "returns an error for an unsuccessful download", context do
      {:error, response} = Downstream.post(@error_url, context.io_device)

      assert response.status_code == 405
    end

    test "accepts a configurable timeout", context do
      {:error, response} = Downstream.get(@get_success_url, context.io_device, timeout: 0)

      assert response.reason == :timeout
    end
  end

  describe "post!/4" do
    setup _context do
      {:ok, pid} = StringIO.open("post! test")

      [io_device: pid]
    end

    test "successfully downloads a file with a post request", context do
      response = Downstream.post!(@post_success_url, context.io_device)

      assert response.device == context.io_device
      assert response.status_code == 200
      assert is_binary(StringIO.flush(response.device))
    end

    test "raises an error for an unsuccessful download", context do
      assert_raise Error, fn ->
        Downstream.post!(@error_url, context.io_device)
      end
    end
  end
end
