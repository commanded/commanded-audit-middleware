defmodule Commanded.Middleware.Auditing.CommandAudit do
  use Ecto.Schema

  @data_column_schema_type Application.compile_env(
                             :commanded_audit_middleware,
                             :data_column_schema_type,
                             :binary
                           )
  @metadata_column_schema_type Application.compile_env(
                                 :commanded_audit_middleware,
                                 :metadata_column_schema_type,
                                 :binary
                               )

  @schema_prefix Application.compile_env(:commanded_audit_middleware, :prefix, "public")
  @primary_key {:command_uuid, :string, []}

  schema "command_audit" do
    field(:causation_id, :binary_id)
    field(:correlation_id, :binary_id)
    field(:occurred_at, :naive_datetime_usec)
    field(:command_type, :string)
    field(:data, @data_column_schema_type)
    field(:metadata, @metadata_column_schema_type)
    field(:success, :boolean)
    field(:execution_duration_usecs, :integer)
    field(:error, :string)
    field(:error_reason, :string)
  end
end
