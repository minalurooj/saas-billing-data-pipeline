select
    customer_id,
    trim(customer_name) as customer_name,
    lower(trim(email)) as customer_email,
    trim(country) as customer_country,
    trim(current_address) as customer_current_address,
    cast(signup_date as date) as signup_date

from {{ source('raw', 'customers') }}