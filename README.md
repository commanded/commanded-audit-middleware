# Commanded audit middleware

Command auditing middleware for Commanded CQRS/ES applications.

Records every dispatched command to the configured database storage. Includes whether the command was successfully handled, or any error.

## Installation

  1. Add `commanded_audit_middleware` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:commanded_audit_middleware, github: "slashdotdash/commanded-audit-middleware"}]
    end
    ```

  2. Ensure `commanded_audit_middleware` is started before your application:

    ```elixir
    def application do
      [applications: [:commanded_audit_middleware]]
    end
    ```
