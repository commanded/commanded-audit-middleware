defmodule Commanded.Middleware.Auditing.Repo.Migrations.CreateGinIndexOnCommandstoreCommandAuditData do
  use Ecto.Migration

  def up do
    execute "CREATE INDEX command_audit_data_gin ON command_audit USING GIN (data);"
  end

  def down do
    execute "DROP INDEX command_audit_data_gin;"
  end
end
