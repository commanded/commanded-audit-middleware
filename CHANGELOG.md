# Changelog

## 0.2.0

### Enhancements

- Support Commanded v0.15.0.
- Include `causation_id` and `correlation_id`.

### Upgrading

You must migrate any existing audit database using the following mix command:

```console
$ mix ecto.migrate -r Commanded.Middleware.Auditing.Repo
```
