defmodule Commanded.Middleware.Auditing.Repo do
  use Ecto.Repo,
    otp_app: :commanded_audit_middleware,
    adapter: Ecto.Adapters.Postgres
end
