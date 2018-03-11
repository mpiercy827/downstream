defmodule Downstream.Options do
  @moduledoc """
  A struct that encapsulates the options used in the Downstream.Download module.
  """

  defstruct file: nil,
            file_path: ""

  @type t :: [
          file: pid,
          file_path: binary
        ]
end
