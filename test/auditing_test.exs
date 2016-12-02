defmodule Commanded.Middleware.AuditingTest do
  use ExUnit.Case

  alias Commanded.Middleware.Auditing
  alias Commanded.Middleware.Auditing.{CommandAudit,Repo}
  alias Commanded.Middleware.Pipeline

  defmodule Command do
    defstruct [
      name: nil,
      age: nil,
    ]
  end

  describe "before command dispatch" do
    setup [:execute_before_dispatch, :get_audit]

    test "should record command", %{audit: audit} do
      assert audit != nil
      assert audit.success == nil
    end
  end

  describe "after successful command dispatch" do
    setup [:execute_before_dispatch, :execute_after_dispatch, :get_audit]

    test "should record success", %{audit: audit} do
      assert audit.success == true
      assert audit.error == nil
      assert audit.error_reason == nil
      assert audit.execution_duration_usecs > 0
    end
  end

  describe "after failed command dispatch" do
    setup [:execute_before_dispatch, :execute_after_failure, :get_audit]

    test "should record failure", %{audit: audit} do
      assert audit.success == false
      assert audit.error == ":failed"
      assert audit.error_reason == "\"failure\""
      assert audit.execution_duration_usecs > 0
    end
  end

  describe "after failed command dispatch but no reason" do
    setup [:execute_before_dispatch, :execute_after_failure_no_reason, :get_audit]

    test "should record failure", %{audit: audit} do
      assert audit.success == false
      assert audit.error == ":failed"
      assert audit.error_reason == nil
      assert audit.execution_duration_usecs > 0
    end
  end

  defp execute_before_dispatch(_context) do
    [pipeline: Auditing.before_dispatch(%Pipeline{
      assigns: %{user: "user@example.com"},
      command: %Command{name: "Ben", age: 34},
    })]
  end

  defp execute_after_dispatch(%{pipeline: pipeline}) do
    [pipeline: Auditing.after_dispatch(pipeline)]
  end

  defp execute_after_failure(%{pipeline: pipeline}) do
    pipeline =
      pipeline
      |> Pipeline.assign(:error, :failed)
      |> Pipeline.assign(:error_reason, "failure")
      |> Auditing.after_failure

    [pipeline: pipeline]
  end

  defp execute_after_failure_no_reason(%{pipeline: pipeline}) do
    pipeline =
      pipeline
      |> Pipeline.assign(:error, :failed)
      |> Auditing.after_failure

    [pipeline: pipeline]
  end

  defp get_audit(%{pipeline: pipeline}) do
    [audit: Repo.get(CommandAudit, pipeline.assigns.command_uuid)]
  end
end
