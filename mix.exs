defmodule Commanded.Middleware.Auditing.Mixfile do
  use Mix.Project

  def project do
    [
      app: :commanded_audit_middleware,
      version: "0.4.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      preferred_cli_env: preferred_cli_env()
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

  defp elixirc_paths(env) when env in [:jsonb, :test], do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.reset --quiet", "test"],
      "test.all": ["test", "test.jsonb"],
      "test.jsonb": &test_jsonb/1
    ]
  end

  defp preferred_cli_env do
    [
      "test.all": :test,
      "test.jsonb": :test
    ]
  end

  defp test_jsonb(args), do: test_env(:jsonb, args)

  defp test_env(env, args) do
    test_args = if IO.ANSI.enabled?(), do: ["--color" | args], else: ["--no-color" | args]

    IO.puts("==> Running tests for MIX_ENV=#{env} mix test #{Enum.join(args, " ")}")

    run_mix_task(env, ["test" | test_args])
  end

  defp run_mix_task(env, args) do
    {_, res} =
      System.cmd(
        "mix",
        args,
        into: IO.binstream(:stdio, :line),
        env: [{"MIX_ENV", to_string(env)}]
      )

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end
  end
end
