import Config

config :commanded_audit_middleware,
  ecto_repos: [Commanded.Middleware.Auditing.Repo],
  serializer: Commanded.Serialization.JsonSerializer

import_config "#{Mix.env()}.exs"
