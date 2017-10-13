Application.stop(:commanded_audit_middleware)

ExUnit.start()

Mix.Task.run "ecto.reset", ~w(--quiet)

Application.ensure_all_started(:commanded_audit_middleware)
