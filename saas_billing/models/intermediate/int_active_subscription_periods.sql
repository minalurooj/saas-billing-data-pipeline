with events as (
    select
        e.subscription_id,
        e.customer_id,
        e.plan_id,
        e.subscription_event_type as start_reason,
        e.subscription_event_timestamp as valid_from
    from {{ ref('stg_subscription_events') }} e
),

events_priced as (
    select
        ev.subscription_id,
        ev.customer_id,
        ev.plan_id,
        ev.start_reason,
        ev.valid_from,
        case
            when ph.billing_interval = 'annual' then ph.plan_price / 12.0
            else ph.plan_price
        end as mrr_amount
    from events ev
    left join {{ ref('int_plan_history') }} ph
        on ev.plan_id = ph.plan_id
        and ev.valid_from >= ph.valid_from
        and ev.valid_from < ph.valid_to
),

history as (
    select
        subscription_id,
        customer_id,
        plan_id,
        mrr_amount,
        start_reason,
        valid_from,
        lead(valid_from) over (
            partition by subscription_id order by valid_from asc
        ) as valid_to,
        row_number() over (partition by subscription_id order by valid_from desc) = 1 as is_current
    from events_priced
)

select
    subscription_id,
    customer_id,
    plan_id,
    mrr_amount,
    start_reason,
    valid_from,
    coalesce(valid_to, '9999-12-31'::timestamp) as valid_to,
    is_current,
    valid_to is null as is_active
from history
where start_reason != 'canceled'