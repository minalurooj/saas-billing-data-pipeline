select

      subscription_id,
      customer_id,
      plan_id,
      lower(trim(status)) as subscription_status,
      cast(start_date as date) as subscription_start_date,
      cast(end_date as date) as subscription_end_date,
      lower(trim(canceled_reason)) as canceled_reason

from {{ source('raw', 'subscriptions')}}