defmodule Commanded.Middleware.Auditing.Supervisor do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Commanded.Middleware.Auditing.Repo, []),
    ]
    opts = [strategy: :one_for_one, name: Commanded.Middleware.Auditing.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
