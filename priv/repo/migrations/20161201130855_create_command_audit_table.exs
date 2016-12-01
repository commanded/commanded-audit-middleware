defmodule Commanded.Middleware.Auditing.Repo.Migrations.CreateCommandAuditTable do
  use Ecto.Migration

  def change do
    create table(:command_audit, primary_key: false) do
      add :command_uuid, :text, primary_key: true
      add :occurred_at, :naive_datetime
      add :command_type, :text
      add :data, :bytea
      add :metadata, :bytea
      add :success, :boolean
      add :execution_duration_usecs, :integer
      add :error, :text
      add :error_reason, :text
    end

    create index(:command_audit, [:occurred_at])
  end

  def down do
    drop table(:command_audit)
  end
end
