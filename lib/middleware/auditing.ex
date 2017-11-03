defmodule Commanded.Middleware.Auditing do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Auditing.CommandAudit
  alias Commanded.Middleware.Auditing.Repo
  alias Commanded.Middleware.Pipeline

  import Pipeline
  import Ecto.Query, only: [from: 2]

  def before_dispatch(%Pipeline{} = pipeline) do
    pipeline
    |> assign(:occurred_at, DateTime.utc_now())
    |> audit()
  end

  def after_dispatch(%Pipeline{} = pipeline) do
    pipeline
    |> success()
  end

  def after_failure(%Pipeline{} = pipeline) do
    pipeline
    |> failure()
  end

  defp audit(%Pipeline{
    assigns: %{occurred_at: occurred_at},
    causation_id: causation_id,
    correlation_id: correlation_id,
    command: command,
    command_uuid: command_uuid,
    metadata: metadata} = pipeline)
  do
    audit = %CommandAudit{
      command_uuid: command_uuid,
      causation_id: causation_id,
      correlation_id: correlation_id,
      occurred_at: occurred_at,
      command_type: Atom.to_string(command.__struct__),
      data: serialize(command),
      metadata: serialize(metadata),
    }

    Repo.insert!(audit)

    pipeline
  end

  defp success(%Pipeline{command_uuid: command_uuid} = pipeline) do
    command_uuid
    |> query_by_command_uuid()
    |> Repo.update_all(set: [
        success: true,
        execution_duration_usecs: delta(pipeline),
      ])

    pipeline
  end

  defp failure(%Pipeline{command_uuid: command_uuid} = pipeline) do
    command_uuid
    |> query_by_command_uuid()
    |> Repo.update_all(set: [
        success: false,
        execution_duration_usecs: delta(pipeline),
        error: extract(pipeline, :error),
        error_reason: extract(pipeline, :error_reason),
      ])

    pipeline
  end

  defp extract(%Pipeline{assigns: assigns}, key) do
    case Map.get(assigns, key) do
      nil -> nil
      value -> inspect(value)
    end
  end

  defp query_by_command_uuid(command_uuid) do
    from audit in CommandAudit,
    where: audit.command_uuid == ^command_uuid
  end

  defp serialize(term),
    do: serializer().serialize(term)

  defp serializer, do: Application.get_env(:commanded_audit_middleware, :serializer)

  # calculate the delta, in usecs, between command occurred at date/time and now
  defp delta(%Pipeline{assigns: %{occurred_at: occurred_at}}) do
    now_usecs = DateTime.utc_now |> DateTime.to_unix(:microseconds)
    occurred_at_usecs = occurred_at |> DateTime.to_unix(:microseconds)

    now_usecs - occurred_at_usecs
  end
end
