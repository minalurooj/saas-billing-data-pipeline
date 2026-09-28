select
change_id,
plan_id,
cast(old_price as decimal(10,2)) as plan_old_price,
cast(new_price as decimal(10,2)) as plan_new_price,
cast(changed_at as timestamp) as plan_changed_at

from {{ source('raw', 'plan_price_changes') }}