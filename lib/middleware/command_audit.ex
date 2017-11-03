defmodule Commanded.Middleware.Auditing.CommandAudit do
  use Ecto.Schema

  @primary_key {:command_uuid, :string, []}

  schema "command_audit" do
    field :causation_id, :binary_id
    field :correlation_id, :binary_id
    field :occurred_at, :naive_datetime
    field :command_type, :string
    field :data, :binary
    field :metadata, :binary
    field :success, :boolean
    field :execution_duration_usecs, :integer
    field :error, :string
    field :error_reason, :string
  end
end
