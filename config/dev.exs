import Config

config :commanded_audit_middleware, Commanded.Middleware.Auditing.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "commanded_audit_middleware_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"
