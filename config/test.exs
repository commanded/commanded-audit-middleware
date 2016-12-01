use Mix.Config

config :commanded_audit_middleware, Commanded.Middleware.Auditing.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "commanded_audit_middleware_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"
