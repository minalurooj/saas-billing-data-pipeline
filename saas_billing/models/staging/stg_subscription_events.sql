select 
event_id,
subscription_id,
customer_id,
lower(trim(event_type)) as subscription_event_type,
plan_id,
cast(event_timestamp as timestamp) as subscription_event_timestamp

from {{ source('raw', 'subscription_events') }}
