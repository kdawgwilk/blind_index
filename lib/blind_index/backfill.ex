defmodule BlindIndex.Backfill do
  @moduledoc false

  @spec perform(atom(), Keyword.t()) :: :ok
  def perform(_schema, _opts \\ [fields: nil, batch_size: 1000]) do
    :ok
  end
end
