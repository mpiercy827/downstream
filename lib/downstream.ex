defmodule Downstream do
  @moduledoc """
  Documentation for Downstream.
  """

  alias Downstream.Download

  @request_timeout 60_000

  @spec get(binary, IO.device(), [{binary, binary}]) :: {atom, binary}
  def get(url, io_device, headers \\ []) do
    download_task = Task.async(Download, :stream, [io_device])

    HTTPoison.get!(url, headers, stream_to: download_task.pid)

    Task.await(download_task, @request_timeout)
  end

  @spec get!(binary, IO.device(), [{binary, binary}]) :: binary
  def get!(url, io_device, headers \\ []) do
    case get(url, io_device, headers) do
      {:error, error} -> raise to_string(error)
      {:ok, io_device} -> io_device
    end
  end

  @spec post(binary, IO.device(), binary | {atom, any}, [{binary, binary}]) :: {atom, binary}
  def post(url, io_device, body \\ "", headers \\ []) do
    download_task = Task.async(Download, :stream, [io_device])

    HTTPoison.post!(url, body, headers, stream_to: download_task.pid)

    Task.await(download_task, @request_timeout)
  end

  @spec post!(binary, IO.device(), binary | {atom, any}, [{binary, binary}]) :: binary
  def post!(url, io_device, body \\ "", headers \\ []) do
    case post(url, io_device, body, headers) do
      {:error, error} -> raise to_string(error)
      {:ok, io_device} -> io_device
    end
  end
end
