select
ticket_id,
customer_id,
lower(trim(category)) as support_ticket_category,
cast(created_at as timestamp) as support_ticket_created_at,
cast(resolved_at as timestamp) as support_ticket_resolved_at

from {{ source('raw', 'support_tickets') }}