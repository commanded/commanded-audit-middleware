defmodule Commanded.Middleware.AuditingTest do
  use ExUnit.Case

  alias Commanded.Middleware.Auditing
  alias Commanded.Middleware.Auditing.{CommandAudit, Repo, UUID}
  alias Commanded.Middleware.Pipeline

  defmodule Command do
    defstruct [:name, :age, :password, :password_confirmation, :secret]
  end

  describe "before command dispatch" do
    setup [
      :execute_before_dispatch,
      :get_audit
    ]

    test "should record command", %{pipeline: pipeline, audit: audit, now: now} do
      refute is_nil(audit)

      refute is_nil(audit.occurred_at)
      assert NaiveDateTime.diff(now, audit.occurred_at) <= 1

      assert audit.causation_id == pipeline.causation_id
      assert audit.correlation_id == pipeline.correlation_id
      assert audit.command_uuid == pipeline.command_uuid

      assert audit.data in [
               "{\"age\":34,\"name\":\"Ben\",\"password\":\"[FILTERED]\",\"password_confirmation\":\"[FILTERED]\",\"secret\":\"[FILTERED]\"}",
               %{
                 "age" => 34,
                 "name" => "Ben",
                 "password" => "[FILTERED]",
                 "password_confirmation" => "[FILTERED]",
                 "secret" => "[FILTERED]"
               }
             ]

      assert audit.metadata in [
               "{\"user\":\"user@example.com\"}",
               %{"user" => "user@example.com"}
             ]

      assert is_nil(audit.success)
      assert is_nil(audit.execution_duration_usecs)
    end
  end

  describe "after successful command dispatch" do
    setup [
      :execute_before_dispatch,
      :execute_after_dispatch,
      :get_audit
    ]

    test "should record success", %{audit: audit} do
      assert audit.success == true
      assert is_nil(audit.error)
      assert is_nil(audit.error_reason)
      assert audit.execution_duration_usecs > 0
    end
  end

  describe "after failed command dispatch" do
    setup [
      :execute_before_dispatch,
      :execute_after_failure,
      :get_audit
    ]

    test "should record failure", %{audit: audit} do
      assert audit.success == false
      assert audit.error == ":failed"
      assert audit.error_reason == "\"failure\""
      assert audit.execution_duration_usecs > 0
    end
  end

  describe "after failed command dispatch but no reason" do
    setup [
      :execute_before_dispatch,
      :execute_after_failure_no_reason,
      :get_audit
    ]

    test "should record failure", %{audit: audit} do
      assert audit.success == false
      assert audit.error == ":failed"
      assert is_nil(audit.error_reason)
      assert audit.execution_duration_usecs > 0
    end
  end

  defp execute_before_dispatch(_context) do
    pipeline =
      %Pipeline{
        causation_id: UUID.uuid4(),
        correlation_id: UUID.uuid4(),
        command: %Command{
          name: "Ben",
          age: 34,
          password: 1234,
          password_confirmation: 1234,
          secret: "I'm superdupersecret!"
        },
        command_uuid: UUID.uuid4(),
        metadata: %{user: "user@example.com"}
      }
      |> Auditing.before_dispatch()

    now = NaiveDateTime.utc_now()

    [pipeline: pipeline, now: now]
  end

  defp execute_after_dispatch(%{pipeline: pipeline}) do
    pipeline = Auditing.after_dispatch(pipeline)

    [pipeline: pipeline]
  end

  defp execute_after_failure(%{pipeline: pipeline}) do
    pipeline =
      pipeline
      |> Pipeline.assign(:error, :failed)
      |> Pipeline.assign(:error_reason, "failure")
      |> Auditing.after_failure()

    [pipeline: pipeline]
  end

  defp execute_after_failure_no_reason(%{pipeline: pipeline}) do
    pipeline =
      pipeline
      |> Pipeline.assign(:error, :failed)
      |> Auditing.after_failure()

    [pipeline: pipeline]
  end

  defp get_audit(%{pipeline: %Pipeline{command_uuid: command_uuid}}) do
    audit = Repo.get(CommandAudit, command_uuid)

    [audit: audit]
  end
end
