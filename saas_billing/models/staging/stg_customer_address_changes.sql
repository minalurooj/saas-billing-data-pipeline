select 
change_id,
customer_id,
trim(old_address) as customer_old_address,
trim(new_address) as customer_new_address,
cast(changed_at as timestamp) as address_changed_at

from {{ source('raw', 'customer_address_changes') }}