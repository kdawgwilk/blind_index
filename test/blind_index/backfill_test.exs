defmodule BlindIndex.BackfillTest do
  use ExUnit.Case
  alias BlindIndex.Backfill
  doctest BlindIndex.Backfill

  defmodule TestSchema do
    use Ecto.Schema
    import BlindIndex, only: [blind_index: 1]

    schema "users" do
      blind_index(:email)
    end
  end

  describe "perform/2" do
    test "" do
      assert :ok == Backfill.perform(TestSchema)
    end
  end
end
