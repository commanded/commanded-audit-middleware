defmodule Commanded.Middleware.Auditing.Repo.Migrations.AddCausationCorrelationIds do
  use Ecto.Migration

  @prefix Application.compile_env(:commanded_audit_middleware, :prefix, "public")

  def change do
    alter table(:command_audit, prefix: @prefix) do
      add :causation_id, :uuid
      add :correlation_id, :uuid
    end
  end
end
