defmodule Commanded.Middleware.Auditing.Repo.Migrations.CreateGinIndexOnCommandstoreCommandAuditData do
  use Ecto.Migration

  @prefix Application.compile_env(:commanded_audit_middleware, :prefix, "public")

  def up do
    if Application.get_env(:commanded_audit_middleware, :data_column_db_type, :bytea) == :jsonb do
      execute(
        "CREATE INDEX IF NOT EXISTS command_audit_data_gin ON #{@prefix}.command_audit USING GIN (data);"
      )
    end

    if Application.get_env(:commanded_audit_middleware, :metadata_column_db_type, :bytea) ==
         :jsonb do
      execute(
        "CREATE INDEX IF NOT EXISTS command_audit_metadata_gin ON #{@prefix}.command_audit USING GIN (metadata);"
      )
    end
  end

  def down do
    execute("DROP INDEX IF EXISTS command_audit_metadata_gin;")
    execute("DROP INDEX IF EXISTS command_audit_data_gin;")
  end
end
