select 
invoice_id,
subscription_id,
customer_id,
cast(amount as decimal(10,2)) as invoice_amount,
trim(lower(status)) as invoice_status,
cast(issued_date as date) as invoice_issued_date,
cast(paid_date as date) as invoice_paid_date

from {{ source('raw', 'invoices') }}