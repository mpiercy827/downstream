defmodule Downstream.Error do
  @moduledoc """
  A generic error that is thrown by the `Downstream` library.
  """

  defexception device: nil, reason: nil, status_code: nil

  @type t :: %__MODULE__{device: IO.device(), reason: any, status_code: non_neg_integer()}

  def message(%__MODULE__{reason: reason}), do: inspect(reason)
end
