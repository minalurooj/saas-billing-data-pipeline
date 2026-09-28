select
    movement_month,
    movement_type,
    count(distinct subscription_id) as subscriptions_affected,
    sum(mrr_delta) as total_mrr_delta

from {{ ref('fct_mrr_movements') }}
group by movement_month, movement_type
order by movement_month, movement_type