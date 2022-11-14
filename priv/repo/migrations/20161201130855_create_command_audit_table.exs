defmodule Commanded.Middleware.Auditing.Repo.Migrations.CreateCommandAuditTable do
  use Ecto.Migration

  @prefix Application.compile_env(:commanded_audit_middleware, :prefix, "public")

  @data_column_db_type Application.compile_env(
                         :commanded_audit_middleware,
                         :data_column_db_type,
                         :bytea
                       )

  @metadata_column_db_type Application.compile_env(
                             :commanded_audit_middleware,
                             :metadata_column_db_type,
                             :bytea
                           )

  def change do
    create table(:command_audit, primary_key: false, prefix: @prefix) do
      add(:command_uuid, :text, primary_key: true)
      add(:occurred_at, :naive_datetime)
      add(:command_type, :text)
      add(:data, @data_column_db_type, null: false, default: "{}")
      add(:metadata, @metadata_column_db_type, null: false, default: "{}")
      add(:success, :boolean)
      add(:execution_duration_usecs, :integer)
      add(:error, :text)
      add(:error_reason, :text)
    end

    create index(:command_audit, [:occurred_at], prefix: @prefix)
  end

  def down do
    drop table(:command_audit, prefix: @prefix)
  end
end
