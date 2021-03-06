defmodule Commanded.Middleware.Auditing.Application do
  @moduledoc """
  Command auditing middleware for Commanded CQRS/ES applications.

  Records every dispatched command to the configured database storage. Includes
  whether the command was successfully handled, or any error.
  """

  use Application

  def start(_type, _args) do
    children = [
      Commanded.Middleware.Auditing.Repo
    ]

    opts = [strategy: :one_for_one, name: Commanded.Middleware.Auditing.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
