defmodule BlindIndexTest do
  use ExUnit.Case
  doctest BlindIndex

  defmodule TestSchema do
    use Ecto.Schema
    import BlindIndex, only: [blind_index: 1]

    schema "users" do
      blind_index(:email)
    end
  end

  describe "blind_index/2" do
    test "generates ecto field" do
    end
  end

  describe "generate_key/0" do
    test "" do
    end
  end

  describe "master_key/0" do
    test "" do
    end
  end
end
