select
  occurred_at,
  command_uuid,
  causation_id,
  correlation_id,
  command_type,
  convert_from(data, current_setting('server_encoding')) as data,
  convert_from(metadata, current_setting('server_encoding')) as metadata,
  success,
  error,
  error_reason,
  execution_duration_usecs,
  execution_duration_usecs/1000 as execution_duration_ms,
  execution_duration_usecs/1000000 as execution_duration_s
from command_audit
order by occurred_at DESC
limit 50;
