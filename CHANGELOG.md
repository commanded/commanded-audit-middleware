# Changelog

## v1.0.0

### Enhancements

- Support Commanded v1.0.0. ([#10](https://github.com/commanded/commanded-audit-middleware/pull/10))
- Support `jsonb` column data type for data and metadata audit fields ([#9](https://github.com/commanded/commanded-audit-middleware/pull/9)).

## v0.4.0

### Enhancements

- Support Commanded v0.18.0.
- Upgrade to Ecto 3 and migrate to elixir_uuid ([#7](https://github.com/commanded/commanded-audit-middleware/pull/7)).
- Fix deprecated time unit warning ([#8](https://github.com/commanded/commanded-audit-middleware/pull/8)).
- Use `:naive_datetime_usec` type for command audit `occurred_at` field.

## v0.3.0

### Enhancements

- Filter specific fields from audited commands ([#2](https://github.com/commanded/commanded-audit-middleware/issues/2)).

## v0.2.1

### Enhancements

- Use `System.monotonic_time/1` to calculate command execution duration.

## v0.2.0

### Enhancements

- Support Commanded v0.15.0.
- Include `causation_id` and `correlation_id`.

### Upgrading

You must migrate any existing audit database using the following mix command:

```console
$ mix ecto.migrate -r Commanded.Middleware.Auditing.Repo
```
