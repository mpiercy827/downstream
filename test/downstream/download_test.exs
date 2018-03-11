defmodule Downstream.DownloadTest do
  use ExUnit.Case

  alias Downstream.{Download, Options}
  alias HTTPoison.{AsyncChunk, AsyncEnd, AsyncHeaders, AsyncStatus}

  describe "stream/1" do
    setup _context do
      file_path = "test.txt"
      {:ok, pid} = StringIO.open(file_path)

      [options: %Options{file: pid, file_path: file_path}]
    end

    test "returns file_path after normal request flow", context do
      options = context[:options]

      task = Task.async(Download, :stream, [options])

      Process.send(task.pid, %AsyncStatus{code: 200}, [:nosuspend])
      Process.send(task.pid, %AsyncHeaders{headers: []}, [:nosuspend])
      Process.send(task.pid, %AsyncChunk{chunk: "test"}, [:nosuspend])
      Process.send(task.pid, %AsyncEnd{}, [:nosuspend])

      assert Task.await(task) == {:ok, "test.txt"}
      assert StringIO.flush(options.file) == "test"
    end

    test "handles unexpected status codes", context do
      task = Task.async(Download, :stream, [context[:options]])

      Process.send(task.pid, %AsyncStatus{code: 401}, [:nosuspend])

      assert Task.await(task) == {:error, :status_code, 401}
    end

    test "handles unexpected messages", context do
      task = Task.async(Download, :stream, [context[:options]])

      Process.send(task.pid, :invalid_message, [:nosuspend])

      assert Task.await(task) == {:error, :unexpected_error}
    end

    test "times out after 5 seconds of no messages", context do
      task = Task.async(Download, :stream, [context[:options]])

      Process.sleep(5_000)

      assert Task.await(task) == {:error, :message_timeout}
    end
  end
end
