defmodule Downstream.Download do
  @moduledoc """
  The `Downstream.Download` module processes `HTTPoison` asynchronous requests.
  """

  alias Downstream.{Error, Response}
  alias HTTPoison.{AsyncChunk, AsyncEnd, AsyncHeaders, AsyncStatus}

  @dialyzer {:no_return, stream: 1, stream: 2}

  def stream(request_params, response \\ %Response{}) do
    receive do
      response_chunk -> handle_response_chunk(response_chunk, request_params, response)
    end
  end

  defp handle_response_chunk(%AsyncStatus{code: 200}, request_params, response) do
    stream(request_params, %Response{response | status_code: 200})
  end

  defp handle_response_chunk(%AsyncStatus{code: code}, request_params, _response) do
    {:error, %Error{device: request_params.io_device, reason: :invalid_status_code, status_code: code}}
  end

  defp handle_response_chunk(%AsyncHeaders{headers: headers}, request_params, response) do
    stream(request_params, %Response{response | headers: headers})
  end

  defp handle_response_chunk(%AsyncChunk{chunk: data}, request_params, response) do
    IO.binwrite(request_params.io_device, data)
    stream(request_params, response)
  end

  defp handle_response_chunk(%AsyncEnd{}, request_params, response) do
    {:ok, %Response{response | device: request_params.io_device}}
  end

  defp handle_response_chunk(%HTTPoison.AsyncRedirect{to: to}, request_params, _response) do
    IO.puts "========================"
    IO.inspect :aaaaa
    IO.puts "========================"
    params = [to, request_params.io_device, request_params[:body], request_params.options] |> Enum.reject(&is_nil/1)
    apply(Downstream, request_params.type, params)
  end

  defp handle_response_chunk(_, request_params, _response) do
    {:error, %Error{device: request_params.io_device, reason: :unexpected_error}}
  end
end
