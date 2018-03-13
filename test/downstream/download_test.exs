defmodule Downstream.DownloadTest do
  use ExUnit.Case

  alias Downstream.Download
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

      assert Task.await(task) == {:ok, context.io_device}
      assert StringIO.flush(context.io_device) == "data"
    end

    test "handles unexpected status codes", context do
      task = Task.async(Download, :stream, [context.io_device])

      Process.send(task.pid, %AsyncStatus{code: 401}, [:nosuspend])

      assert Task.await(task) == {:error, "status code 401"}
    end

    test "handles unexpected messages", context do
      task = Task.async(Download, :stream, [context.io_device])

      Process.send(task.pid, :invalid_message, [:nosuspend])

      assert Task.await(task) == {:error, "unexpected error"}
    end

    test "times out after 5 seconds of no messages", context do
      task = Task.async(Download, :stream, [context.io_device])

      Process.sleep(5_000)

      assert Task.await(task) == {:error, "request timeout"}
    end
  end
end
