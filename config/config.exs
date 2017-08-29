use Mix.Config

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.InMemory

config :commanded_audit_middleware,
  ecto_repos: [Commanded.Middleware.Auditing.Repo],
  serializer: Commanded.Serialization.JsonSerializer

import_config "#{Mix.env}.exs"
