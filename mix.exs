defmodule Commanded.Middleware.Auditing.Mixfile do
  use Mix.Project

  def project do
    [
      app: :commanded_audit_middleware,
      version: "0.1.2",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases(),
    ]
  end

  def application do
    [
      extra_applications: [
        :logger,
      ],
      mod: {Commanded.Middleware.Auditing.Supervisor, []}
    ]
  end

  defp deps do
    [
      {:commanded, "~> 0.13", runtime: false},
      {:ecto, "~> 2.2"},
      {:mix_test_watch, "~> 0.5", only: :dev},
      {:postgrex, "~> 0.13"},
      {:uuid, "~> 1.1"},
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
