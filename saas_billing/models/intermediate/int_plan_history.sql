with earliest_change as (
    select
        plan_id,
        plan_old_price as plan_price,
        plan_changed_at as valid_from,
        row_number() over (partition by plan_id order by plan_changed_at asc) as rn
    from {{ ref('stg_plan_price_changes') }}
),

earliest_change_only as (
    select plan_id, plan_price, valid_from
    from earliest_change
    where rn = 1
),

base_plan as (
    select
        p.plan_id,
        p.plan_name,
        p.billing_interval,
        coalesce(ec.plan_price, p.current_price) as plan_price,
        p.created_at as valid_from
    from {{ ref('stg_plans') }} p
    left join earliest_change_only ec
        on p.plan_id = ec.plan_id
),

changes as (
    select 
        c.plan_id,
        p.plan_name,
        p.billing_interval,
        c.plan_new_price as plan_price,
        c.plan_changed_at as valid_from
    from {{ ref('stg_plan_price_changes') }} c
    left join {{ ref('stg_plans') }} p 
        on c.plan_id = p.plan_id
),

unioned as (
    select plan_id, plan_name, billing_interval, plan_price, valid_from from base_plan
    union all
    select plan_id, plan_name, billing_interval, plan_price, valid_from from changes
),

versioned as (
    select
        plan_id,
        plan_name,
        billing_interval,
        plan_price,
        valid_from,
        lead(valid_from) over (
            partition by plan_id order by valid_from asc
        ) as valid_to,
        row_number() over (
            partition by plan_id order by valid_from desc
        ) = 1 as is_current
    from unioned
)

select 
    plan_id,
    plan_name,
    billing_interval,
    plan_price,
    valid_from,
    coalesce(valid_to, '9999-12-31'::timestamp) as valid_to,
    is_current
from versioned