# Commanded audit middleware

Command auditing middleware for [Commanded](https://github.com/slashdotdash/commanded) CQRS/ES applications.

Records every dispatched command to the configured database storage. Includes whether the command was successfully handled, or any error.

## Installation

  1. Add `commanded_audit_middleware` to your list of dependencies in `mix.exs`:

      ```elixir
      def deps do
        [
          {:commanded_audit_middleware, github: "slashdotdash/commanded-audit-middleware"},
        ]
      end
      ```

  2. Ensure `commanded_audit_middleware` is started before your application:

      ```elixir
      def application do
        [
          applications: [
            :commanded_audit_middleware,
          ]
        ]
      end
      ```

  3. Add the following config section to `config/config.exs`:

      ```elixir
      config :commanded_audit_middleware,
        ecto_repos: [Commanded.Middleware.Auditing.Repo],
        serializer: Commanded.Serialization.JsonSerializer
      ```

  4. Add the following config section to each environment's config (e.g. `config/dev.exs`):

      ```elixir
      config :commanded_audit_middleware, Commanded.Middleware.Auditing.Repo,
        adapter: Ecto.Adapters.Postgres,
        database: "commanded_audit_middleware_dev",
        username: "postgres",
        password: "postgres",
        hostname: "localhost",
        port: "5432"
      ```

  5. Create and migrate the command audit database:

      ```console
      $ mix ecto.create -r Commanded.Middleware.Auditing.Repo
      $ mix ecto.migrate -r Commanded.Middleware.Auditing.Repo
      ```

  6. Add the middleware to your application's Commanded router.

      ```elixir
      defmodule Router do
        use Commanded.Commands.Router

        middleware Commanded.Middleware.Auditing
      end
      ```
