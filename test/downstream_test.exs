defmodule DownstreamTest do
  use ExUnit.Case
  import Mimic
  doctest Downstream

  alias Downstream.{Download, Error, Response}

  @success_url "https://httpstat.us/200"
  @error_url "https://httpstat.us/403"

  describe "get/3" do
    setup :verify_on_exit!
    setup :set_mimic_global

    setup _context do
      {:ok, pid} = StringIO.open("get test")

      [io_device: pid]
    end

    test "successfully downloads a file with a get request", context do
      stub(Download, :stream, fn _ ->
        {:ok, %Response{device: context.io_device, status_code: 200}}
      end)

      {:ok, response} = Downstream.get(@success_url, context.io_device)

      assert response.device == context.io_device
      assert response.status_code == 200
    end

    test "returns an error for an unsuccessful download", context do
      stub(Download, :stream, fn _ ->
        {:error, %Error{status_code: 403}}
      end)

      {:error, response} = Downstream.get(@error_url, context.io_device)

      assert response.status_code == 403
    end

    test "accepts a configurable timeout", context do
      stub(Download, :stream, fn _ ->
        {:error, %Error{reason: :timeout}}
      end)

      {:error, error} = Downstream.get(@success_url, context.io_device, timeout: 0)

      assert error.reason == :timeout
    end
  end

  describe "get!/3" do
    setup :verify_on_exit!
    setup :set_mimic_global

    setup _context do
      {:ok, pid} = StringIO.open("get! test")

      [io_device: pid]
    end

    test "successfully downloads a file with a get request", context do
      stub(Download, :stream, fn _ ->
        {:ok, %Response{device: context.io_device, status_code: 200}}
      end)

      response = Downstream.get!(@success_url, context.io_device)

      assert response.device == context.io_device
      assert response.status_code == 200
    end

    test "raises an error for an unsuccessful download", context do
      stub(Download, :stream, fn _ ->
        {:error, %Error{status_code: 403}}
      end)

      assert_raise Error, fn ->
        Downstream.get!(@error_url, context.io_device)
      end
    end
  end

  describe "post/4" do
    setup :verify_on_exit!
    setup :set_mimic_global

    setup _context do
      {:ok, pid} = StringIO.open("post test")

      [io_device: pid]
    end

    test "successfully downloads a file with a post request", context do
      stub(Download, :stream, fn _ ->
        {:ok, %Response{device: context.io_device, status_code: 200}}
      end)

      {:ok, response} = Downstream.post(@success_url, context.io_device)

      assert response.device == context.io_device
      assert response.status_code == 200
    end

    test "returns an error for an unsuccessful download", context do
      stub(Download, :stream, fn _ ->
        {:error, %Error{status_code: 403}}
      end)

      {:error, error} = Downstream.post(@error_url, context.io_device)

      assert error.status_code == 403
    end

    test "accepts a configurable timeout", context do
      stub(Download, :stream, fn _ ->
        {:error, %Error{reason: :timeout}}
      end)

      {:error, error} = Downstream.get(@success_url, context.io_device, timeout: 0)

      assert error.reason == :timeout
    end
  end

  describe "post!/4" do
    setup :verify_on_exit!
    setup :set_mimic_global

    setup _context do
      {:ok, pid} = StringIO.open("post! test")

      [io_device: pid]
    end

    test "successfully downloads a file with a post request", context do
      stub(Download, :stream, fn _ ->
        {:ok, %Response{device: context.io_device, status_code: 200}}
      end)

      response = Downstream.post!(@success_url, context.io_device)

      assert response.device == context.io_device
      assert response.status_code == 200
    end

    test "raises an error for an unsuccessful download", context do
      stub(Download, :stream, fn _ ->
        {:error, %Error{status_code: 403}}
      end)

      assert_raise Error, fn ->
        Downstream.post!(@error_url, context.io_device)
      end
    end
  end
end
