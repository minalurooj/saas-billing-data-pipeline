select 
    plan_id,
    trim(plan_name) as plan_name,
    lower(trim(billing_interval)) as billing_interval,
    cast(current_price as numeric(10,2)) as current_price,
    cast(created_at as timestamp) as created_at

from {{ ref('plans') }}

