select
    plan_id,
    plan_name,
    billing_interval,
    plan_price as current_price
from {{ ref('int_plan_history') }}
where is_current