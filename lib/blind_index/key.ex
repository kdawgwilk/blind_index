defmodule BlindIndex.Key do
  @moduledoc false

  @type t :: %__MODULE__{
          master_key: String.t(),
          bytesize: pos_integer(),
          encoding: :binary
        }

  @enforce_keys [:master_key, :bytesize, :encoding]
  defstruct [:master_key, :bytesize, :encoding]

  @spec index_key(__MODULE__.t(), String.t(), String.t()) :: String.t()
  def index_key(%__MODULE__{} = _master_key, _table_name, _bidx_column_name) do
    ""
  end
end
