defmodule Downstream.DownloadTest do
  use ExUnit.Case

  alias Downstream.{Download, Error, Response}
  alias HTTPoison.{AsyncChunk, AsyncEnd, AsyncHeaders, AsyncStatus}

  describe "stream/1" do
    setup _context do
      {:ok, pid} = StringIO.open("test")

      [io_device: pid]
    end

    test "returns file_path after normal request flow", context do
      task = Task.async(Download, :stream, [context.io_device])

      Process.send(task.pid, %AsyncStatus{code: 200}, [:nosuspend])
      Process.send(task.pid, %AsyncHeaders{headers: []}, [:nosuspend])
      Process.send(task.pid, %AsyncChunk{chunk: "data"}, [:nosuspend])
      Process.send(task.pid, %AsyncEnd{}, [:nosuspend])

      {:ok, %Response{device: device, headers: headers, status_code: code}} = Task.await(task)

      assert device == context.io_device
      assert code == 200
      assert is_list(headers)

      assert StringIO.flush(context.io_device) == "data"
    end

    test "handles unexpected status codes", context do
      task = Task.async(Download, :stream, [context.io_device])

      Process.send(task.pid, %AsyncStatus{code: 401}, [:nosuspend])

      {:error, %Error{device: device, reason: :invalid_status_code, status_code: code}} =
        Task.await(task)

      assert device == context.io_device
      assert code == 401
    end

    test "handles unexpected messages", context do
      task = Task.async(Download, :stream, [context.io_device])

      Process.send(task.pid, :invalid_message, [:nosuspend])

      {:error, %Error{device: device, reason: error}} = Task.await(task)

      assert device == context.io_device
      assert error == :unexpected_error
    end
  end
end
