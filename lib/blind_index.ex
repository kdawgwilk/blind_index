defmodule BlindIndex do
  @moduledoc """
  Documentation for `BlindIndex`.
  """

  alias BlindIndex.Backfill
  alias BlindIndex.Key

  @spec blind_index(atom(), Keyword.t()) :: Macro.t()
  @doc """
  # Examples

  iex> defmodule Person do
  ...>   use Ecto.Schema
  ...>   import BlindIndex, only: [blind_index: 1]
  ...>
  ...>   schema "users" do
  ...>     blind_index :email
  ...>   end
  ...> end
  """
  defmacro blind_index(field_name, _opts \\ []) when is_atom(field_name) do
    quote do
      field(:"#{unquote(field_name)}_bidx", :string)
    end
  end

  @spec backfill(atom()) :: :ok
  @doc """
  # Examples

  iex> BlindIndex.backfill(Person)
  :ok

  iex> BlindIndex.backfill(Person, [fields: [:email_bidx]])
  :ok
  """
  def backfill(schema, opts \\ [fields: nil, batch_size: 1000]),
    do: Backfill.perform(schema, opts)

  @spec index_key(String.t(), String.t(), Key.t() | nil, boolean()) :: String.t()
  @doc """
  # Examples

  iex> BlindIndex.index_key("users", "email_bidx")
  ""
  """
  def index_key(_table_name, _bidx_column_name, _master_key \\ nil, _encode \\ true) do
    ""
  end

  @spec generate_key() :: String.t()
  @doc """
  # Examples

  iex> BlindIndex.generate_key()
  "c2c3a0574a8e633d1de56034d2057a83af7989586228a3b4736fd61df35ee995"
  """
  def generate_key() do
    :crypto.strong_rand_bytes(32) |> Base.encode16(case: :lower)
  end

  @spec master_key() :: String.t()
  def master_key() do
    Application.get_env(:blind_index, :master_key)
  end
end
