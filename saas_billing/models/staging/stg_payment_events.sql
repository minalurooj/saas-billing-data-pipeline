select
payment_event_id,
invoice_id,
lower(trim(event_type)) as payment_event_type,
cast(event_timestamp as timestamp) as payment_event_timestamp,
cast(_loaded_at as timestamp) as payment_loaded_at
from {{ source('raw', 'payment_events') }}