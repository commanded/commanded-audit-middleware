defmodule Commanded.Middleware.Auditing.Mixfile do
  use Mix.Project

  def project do
    [
      app: :commanded_audit_middleware,
      version: "0.4.0",
      elixir: "~> 1.7",
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [
        :logger,
        :ecto_sql
      ],
      mod: {Commanded.Middleware.Auditing.Supervisor, []}
    ]
  end

  defp description do
    """
    Command auditing middleware for Commanded CQRS/ES applications
    """
  end

  defp package do
    [
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Ben Smith"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/commanded/commanded-audit-middleware"
      }
    ]
  end

  defp deps do
    [
      {:commanded, ">= 0.18.0", runtime: false},
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0"},
      {:elixir_uuid, "~> 1.2"},
      {:ex_doc, "~> 0.19", only: :dev},
      {:jason, "~> 1.1"},
      {:postgrex, "~> 0.14.0"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.reset --quiet", "test"]
    ]
  end
end
