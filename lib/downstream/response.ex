defmodule Downstream.Response do
  @moduledoc """
  The `Downstream.Response` module provides a struct for storing response
  information, including status code and headers.
  """

  defstruct device: nil, headers: [], status_code: nil

  @type headers :: [{atom, binary}] | [{binary, binary}] | %{binary => binary} | any
  @type t :: %__MODULE__{
          device: IO.device(),
          headers: headers,
          status_code: non_neg_integer
        }
end
