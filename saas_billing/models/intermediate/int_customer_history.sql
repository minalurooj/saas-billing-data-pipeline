with earliest_change as (
    select
        customer_id,
        customer_old_address as customer_address,
        address_changed_at as valid_from,
        row_number() over (partition by customer_id order by address_changed_at asc) as rn
    from {{ ref('stg_customer_address_changes') }}
),

earliest_change_only as (
    select customer_id, customer_address, valid_from
    from earliest_change
    where rn = 1
),

base_address as (
    select
        c.customer_id,
        coalesce(ec.customer_address, c.customer_current_address) as customer_address,
        c.signup_date as valid_from
    from {{ ref('stg_customers') }} c
    left join earliest_change_only ec
        on c.customer_id = ec.customer_id
),

changed as (
    select customer_id,
    customer_new_address as customer_address,
    address_changed_at as valid_from
    from {{ ref('stg_customer_address_changes') }}
),

unioned as (
    select customer_id, customer_address, valid_from from base_address
    union all
    select customer_id, customer_address, valid_from from changed
),

history as (
    select customer_id,
    customer_address,
    valid_from,
    lead(valid_from) over (partition by customer_id order by valid_from asc) as valid_to,
    row_number() over (partition by customer_id order by valid_from desc) = 1 as is_current
    from unioned
)

select customer_id,
       customer_address,
       valid_from,
       coalesce(valid_to, '9999-12-31'::timestamp) as valid_to,
       is_current
from history