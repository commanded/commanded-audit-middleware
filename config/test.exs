use Mix.Config

config :ex_unit,
  capture_log: true

config :commanded_audit_middleware, Commanded.Middleware.Auditing.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "commanded_audit_middleware_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"
