with successful_payments as (
    select distinct invoice_id
    from {{ ref('stg_payment_events') }}
    where payment_event_type = 'success'
),

refunded_payments as (
    select distinct invoice_id
    from {{ ref('stg_payment_events') }}
    where payment_event_type = 'refund'
),
billing as (
    select
        i.customer_id,

        round(sum(i.invoice_amount)::numeric,2) as total_invoiced,


        ROUND(
    SUM(
        CASE
            WHEN sp.invoice_id IS NOT NULL
             AND rp.invoice_id IS NULL
            THEN i.invoice_amount
            ELSE 0
        END
    )::numeric, 2
) AS total_paid,


        round(
        sum(
            case
                when i.invoice_status != 'paid'
                then i.invoice_amount
                else 0
            end
        )::numeric,2
        )as total_outstanding

    from {{ ref('stg_invoices') }} i

    left join successful_payments sp
        on i.invoice_id = sp.invoice_id

    left join refunded_payments rp
        on i.invoice_id = rp.invoice_id

    group by i.customer_id
),

support as (
    select
        customer_id,
        count(*) as total_tickets,
        max(support_ticket_created_at)::timestamp(0) as last_ticket_date
    from {{ ref('stg_support_tickets') }}
    group by customer_id
),

current_mrr as (
    select
        customer_id,
        round(sum(mrr_amount)::numeric,2) as current_mrr
    from {{ ref('int_active_subscription_periods') }}
    where is_current and is_active
    group by customer_id
)

select
    c.customer_id,
    c.customer_name,
    c.customer_email,
    c.customer_country,
    c.signup_date,
    coalesce(mrr.current_mrr, 0) as current_mrr,
    coalesce(b.total_invoiced, 0) as total_invoiced,
    coalesce(b.total_paid, 0) as total_paid,
    coalesce(b.total_outstanding, 0) as total_outstanding,
    coalesce(s.total_tickets, 0) as total_support_tickets,
    s.last_ticket_date

from {{ ref('dim_customers') }} c
left join billing b on c.customer_id = b.customer_id
left join support s on c.customer_id = s.customer_id
left join current_mrr mrr on c.customer_id = mrr.customer_id