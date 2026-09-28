select
    m.subscription_id,
    m.customer_id,
    m.plan_id,
    m.movement_date,
    date_trunc('month', m.movement_date) as movement_month,
    m.previous_mrr,
    m.new_mrr,
    m.mrr_delta,
    m.movement_type

from {{ ref('int_mrr_movements') }} m