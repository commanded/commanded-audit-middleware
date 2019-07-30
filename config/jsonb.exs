use Mix.Config

config :ex_unit,
  capture_log: true

config :commanded_audit_middleware,
  data_column_schema_type: :map,
  data_column_db_type: :jsonb,
  metadata_column_schema_type: :map,
  metadata_column_db_type: :jsonb,
  serializer: JsonbSerializer

config :commanded_audit_middleware, Commanded.Middleware.Auditing.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "commanded_audit_middleware_jsonb_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"
