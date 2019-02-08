defmodule DownstreamTest do
  use ExUnit.Case
  doctest Downstream

  @tag timeout: 5_000

  alias Downstream.Error

  @success_url "https://httpstat.us/200"
  @error_url "https://httpstat.us/404"

  describe "get/3" do
    setup _context do
      {:ok, pid} = StringIO.open("get test")

      [io_device: pid]
    end

    test "successfully downloads a file with a get request", context do
      {:ok, response} = Downstream.get(@success_url, context.io_device)

      assert response.device == context.io_device
      assert response.status_code == 200
      assert is_binary(StringIO.flush(response.device))
    end

    test "returns an error for an unsuccessful download", context do
      {:error, response} = Downstream.get(@error_url, context.io_device)

      assert response.status_code == 404
    end

    test "accepts a configurable timeout", context do
      url = "#{@success_url}?sleep=5000"

      {:error, error} = Downstream.get(url, context.io_device, timeout: 1_000)

      assert error.reason == :timeout
    end
  end

  describe "get!/3" do
    setup _context do
      {:ok, pid} = StringIO.open("get! test")

      [io_device: pid]
    end

    test "successfully downloads a file with a get request", context do
      response = Downstream.get!(@success_url, context.io_device)

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
      {:ok, response} = Downstream.post(@success_url, context.io_device)

      assert response.device == context.io_device
      assert response.status_code == 200
      assert is_binary(StringIO.flush(response.device))
    end

    test "returns an error for an unsuccessful download", context do
      {:error, response} = Downstream.post(@error_url, context.io_device)

      assert response.status_code == 404
    end

    test "accepts a configurable timeout", context do
      url = "#{@success_url}?sleep=5000"

      {:error, response} = Downstream.get(url, context.io_device, timeout: 1_000)

      assert response.reason == :timeout
    end
  end

  describe "post!/4" do
    setup _context do
      {:ok, pid} = StringIO.open("post! test")

      [io_device: pid]
    end

    test "successfully downloads a file with a post request", context do
      response = Downstream.post!(@success_url, context.io_device)

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
