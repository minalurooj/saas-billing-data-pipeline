with current_address as (
    select customer_id, customer_address
    from {{ ref('int_customer_history') }}
    where is_current
)

select
    c.customer_id,
    c.customer_name,
    c.customer_email,
    c.customer_country,
    a.customer_address as current_address,
    c.signup_date

from {{ ref('stg_customers') }} c
left join current_address a
    on c.customer_id = a.customer_id