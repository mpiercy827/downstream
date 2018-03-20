defmodule Downstream.Download do
  @moduledoc """
  The `Downstream.Download` module processes `HTTPoison` asynchronous requests.
  """

  alias HTTPoison.{AsyncChunk, AsyncEnd, AsyncHeaders, AsyncStatus}

  @spec stream(IO.device()) :: tuple
  def stream(io_device) do
    receive do
      response_chunk -> handle_response_chunk(response_chunk, io_device)
    end
  end

  defp handle_response_chunk(%AsyncStatus{code: 200}, io_device) do
    stream(io_device)
  end

  defp handle_response_chunk(%AsyncStatus{code: code}, _io_device) do
    {:error, "status code #{code}"}
  end

  defp handle_response_chunk(%AsyncHeaders{headers: _headers}, io_device) do
    stream(io_device)
  end

  defp handle_response_chunk(%AsyncChunk{chunk: data}, io_device) do
    IO.binwrite(io_device, data)
    stream(io_device)
  end

  defp handle_response_chunk(%AsyncEnd{}, io_device) do
    {:ok, io_device}
  end

  defp handle_response_chunk(_, _io_device) do
    {:error, "unexpected error"}
  end
end
