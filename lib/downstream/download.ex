defmodule Downstream.Download do
  @moduledoc """
  """

  alias Downstream.Options
  alias HTTPoison.{AsyncChunk, AsyncEnd, AsyncHeaders, AsyncStatus}

  @message_timeout 5_000

  @spec stream(Options.t() | map) :: tuple
  def stream(options) do
    receive do
      response_chunk -> handle_response_chunk(response_chunk, options)
    after
      @message_timeout -> {:error, :message_timeout}
    end
  end

  defp handle_response_chunk(%AsyncStatus{code: 200}, options) do
    stream(options)
  end

  defp handle_response_chunk(%AsyncStatus{code: code}, _options) do
    {:error, :status_code, code}
  end

  defp handle_response_chunk(%AsyncHeaders{headers: _headers}, options) do
    stream(options)
  end

  defp handle_response_chunk(%AsyncChunk{chunk: data}, options) do
    IO.binwrite(options.file, data)
    stream(options)
  end

  defp handle_response_chunk(%AsyncEnd{}, options) do
    {:ok, options.file_path}
  end

  defp handle_response_chunk(_, _options) do
    {:error, :unexpected_error}
  end
end
