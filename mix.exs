defmodule Commanded.Middleware.Auditing.Mixfile do
  use Mix.Project

  def project do
    [
      app: :commanded_audit_middleware,
      version: "0.1.3",
      elixir: "~> 1.4",
      description: description(),
      package: package(),
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
      links: %{"GitHub" => "https://github.com/slashdotdash/commanded-audit-middleware",
               "Docs" => "https://hexdocs.pm/commanded_audit_middleware/"}
    ]
  end

  defp deps do
    [
      {:commanded, "~> 0.14", runtime: false},
      {:ecto, "~> 2.2"},
      {:ex_doc, "~> 0.17", only: :dev},
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
