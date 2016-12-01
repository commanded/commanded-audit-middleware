defmodule Commanded.Middleware.Auditing.Mixfile do
  use Mix.Project

  def project do
    [
      app: :commanded_audit_middleware,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      aliases: aliases,
    ]
  end

  def application do
    [
      applications: [
        :ecto,
        :logger,
        :postgrex,
      ],
      mod: {Commanded.Middleware.Auditing.Supervisor, []}
    ]
  end

  defp deps do
    [
      {:commanded, "~> 0.8", optional: true},
      {:ecto, "~> 2.1.0-rc.4", override: true},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:postgrex, "~> 1.0.0-rc.1", override: true},
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
