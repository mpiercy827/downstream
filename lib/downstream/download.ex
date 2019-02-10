defmodule Downstream.Download do
  @moduledoc """
  The `Downstream.Download` module processes `HTTPoison` asynchronous requests.
  """

  alias Downstream.{Error, Response}
  alias HTTPoison.{AsyncChunk, AsyncEnd, AsyncHeaders, AsyncStatus}

  @dialyzer {:no_return, stream: 1, stream: 2}

  def stream(io_device, response \\ %Response{}) do
    receive do
      response_chunk -> handle_response_chunk(response_chunk, io_device, response)
    end
  end

  defp handle_response_chunk(%AsyncStatus{code: 200}, io_device, response) do
    stream(io_device, %Response{response | status_code: 200})
  end

  defp handle_response_chunk(%AsyncStatus{code: code}, io_device, _response) do
    {:error, %Error{device: io_device, reason: :invalid_status_code, status_code: code}}
  end

  defp handle_response_chunk(%AsyncHeaders{headers: headers}, io_device, response) do
    stream(io_device, %Response{response | headers: headers})
  end

  defp handle_response_chunk(%AsyncChunk{chunk: data}, io_device, response) do
    IO.binwrite(io_device, data)
    stream(io_device, response)
  end

  defp handle_response_chunk(%AsyncEnd{}, io_device, response) do
    {:ok, %Response{response | device: io_device}}
  end

  defp handle_response_chunk(_, io_device, _response) do
    {:error, %Error{device: io_device, reason: :unexpected_error}}
  end
end
