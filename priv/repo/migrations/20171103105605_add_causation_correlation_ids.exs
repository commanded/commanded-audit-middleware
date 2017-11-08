defmodule Commanded.Middleware.Auditing.Repo.Migrations.AddCausationCorrelationIds do
  use Ecto.Migration

  def change do
    alter table(:command_audit) do
      add :causation_id, :uuid
      add :correlation_id, :uuid
    end
  end
end
