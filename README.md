# Commanded audit middleware

Command auditing middleware for [Commanded](https://github.com/commanded/commanded) CQRS/ES applications.

Records every dispatched command to the configured database storage. Includes whether the command was successfully handled, or any error.

Please refer to the [CHANGELOG](CHANGELOG.md) for features, bug fixes, and any upgrade advice included for each release.

MIT License

[![Build Status](https://travis-ci.com/commanded/commanded-audit-middleware.svg?branch=master)](https://travis-ci.com/commanded/commanded-audit-middleware)

---

## Getting started

1. Add `commanded_audit_middleware` to your list of dependencies in `mix.exs`:

   ```elixir
   def deps do
     [
       {:commanded_audit_middleware, "~> 0.4"},
     ]
   end
   ```

2. Add the following config section to `config/config.exs`:

   ```elixir
   config :commanded_audit_middleware,
     ecto_repos: [Commanded.Middleware.Auditing.Repo],
     serializer: Commanded.Serialization.JsonSerializer
   ```

   If you prefer to instead serialize the `command_audit`'s `data`
   and `metadata` columns as [JSONB](https://www.postgresql.org/docs/current/datatype-json.html)
   (which [can be indexed and queried efficiently](https://www.postgresql.org/docs/current/functions-json.html)),
   choose an Ecto schema type of `:map` and a PostgreSQL database type of `:jsonb`:

   ```elixir
   config :commanded_audit_middleware,
     ecto_repos: [Commanded.Middleware.Auditing.Repo],
     serializer: EventStore.JsonbSerializer,
     data_column_schema_type: :map,
     metadata_column_schema_type: :map,
     data_column_db_type: :jsonb,
     metadata_column_db_type: :jsonb
   ```

3. By default, `commanded_audit_middleware` should filter all `password`, `password_confirmation` and `secret` in your schemas.
   If you want to **override** and define your own filters, you should add the following to your `config/config.exs`:

   ```elixir
   config :commanded_audit_middleware,
     filter_fields: [:credit_card_number, :btc_private_key]
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

5. Fetch and compile mix dependencies:

   ```console
   $ mix do deps.get, deps.compile
   ```

6. Create and migrate the command audit database:

   ```console
   $ mix ecto.create -r Commanded.Middleware.Auditing.Repo
   $ mix ecto.migrate -r Commanded.Middleware.Auditing.Repo
   ```

7. Add the middleware to your application's Commanded router.

   ```elixir
   defmodule Router do
     use Commanded.Commands.Router

     middleware Commanded.Middleware.Auditing
   end
   ```

### Contributing

Pull requests to contribute new or improved features, and extend documentation are most welcome. Please follow the existing coding conventions.

You should include unit tests to cover any changes. Run `mix test` to execute the test suite:

```console
mix deps.get
mix test
```

### Contributors

- [Ben Smith](https://github.com/slashdotdash)
- [CptBreeza](https://github.com/CptBreeza)
- [Iuri L. Machado](https://github.com/imetallica)
- [Mikhail Karavaev](https://github.com/mkaravaev)
