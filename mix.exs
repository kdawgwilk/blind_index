defmodule BlindIndex.MixProject do
  use Mix.Project

  def project() do
    [
      app: :blind_index,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application() do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps() do
    [
      {:ecto_sql, "~> 3.5"},
      {:argon2_elixir, "~> 2.0"}
    ]
  end
end
