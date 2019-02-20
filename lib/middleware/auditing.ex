defmodule Commanded.Middleware.Auditing do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Auditing.CommandAudit
  alias Commanded.Middleware.Auditing.Repo
  alias Commanded.Middleware.Pipeline

  import Pipeline
  import Ecto.Query, only: [from: 2]

  @default_fields_to_filter [:password, :password_confirmation, :secret]

  def before_dispatch(%Pipeline{} = pipeline) do
    pipeline
    |> assign(:start_time, monotonic_time())
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
      data: serialize(filter(command)),
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

  defp filter(data) do
    to_filter = Application.get_env(:commanded_audit_middleware, :filter_fields, @default_fields_to_filter)
    Enum.reduce(Map.from_struct(data), %{}, fn {key, val}, acc -> 
      if key in to_filter do
        Map.put(acc, key, "[FILTERED]")
      else
        Map.put(acc, key, val)
      end
    end)
  end

  defp query_by_command_uuid(command_uuid) do
    from audit in CommandAudit,
    where: audit.command_uuid == ^command_uuid
  end

  defp monotonic_time, do: System.monotonic_time(:microsecond)

  defp serialize(term), do: serializer().serialize(term)

  defp serializer do
    Application.get_env(:commanded_audit_middleware, :serializer) ||
      raise ArgumentError, "Commanded audit middleware expects `:serializer` to be configured"
  end

  # calculate the delta, in microseconds, between command start and end time (now)
  defp delta(%Pipeline{assigns: %{start_time: start_time}}) do
    end_time = monotonic_time()

    end_time - start_time
  end
end
