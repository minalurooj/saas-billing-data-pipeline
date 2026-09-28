DROP TABLE IF EXISTS public.customer_address_changes CASCADE;
DROP TABLE IF EXISTS public.customers CASCADE;
DROP TABLE IF EXISTS public.plan_price_changes CASCADE;
DROP TABLE IF EXISTS public.subscriptions CASCADE;
DROP TABLE IF EXISTS public.subscription_events CASCADE;
DROP TABLE IF EXISTS public.invoices CASCADE;
DROP TABLE IF EXISTS public.payment_events CASCADE;
DROP TABLE IF EXISTS public.support_tickets CASCADE;

CREATE TABLE public.customers (
    customer_id TEXT,
    customer_name TEXT,
    email TEXT,
    country TEXT,
    current_address TEXT,
    signup_date DATE
);

INSERT INTO public.customers VALUES
('cust_001', 'Alice Khan', 'alice@example.com', 'Pakistan', 'Lahore', '2024-01-05'),
('cust_002', 'Bilal Ahmed', 'bilal@example.com', 'Pakistan', 'Karachi', '2024-02-10'),
('cust_003', 'Sara Malik', 'sara@example.com', 'UAE', 'Dubai', '2024-03-15');

CREATE TABLE public.customer_address_changes (
    change_id TEXT,
    customer_id TEXT,
    old_address TEXT,
    new_address TEXT,
    changed_at DATE
);

INSERT INTO public.customer_address_changes VALUES
('addr_001', 'cust_001', 'Islamabad', 'Lahore', '2024-02-01'),
('addr_002', 'cust_002', 'Lahore', 'Karachi', '2024-03-01');

CREATE TABLE public.plan_price_changes (
    change_id TEXT,
    plan_id TEXT,
    old_price DOUBLE PRECISION,
    new_price DOUBLE PRECISION,
    changed_at TIMESTAMP
);

INSERT INTO public.plan_price_changes VALUES
('price_001', 'plan_1', 10.0, 15.0, '2024-04-01 00:00:00');

CREATE TABLE public.subscriptions (
    subscription_id TEXT,
    customer_id TEXT,
    plan_id TEXT,
    status TEXT,
    start_date DATE,
    end_date DATE,
    canceled_reason TEXT
);

INSERT INTO public.subscriptions VALUES
('sub_001', 'cust_001', 'plan_1', 'active', '2024-01-05', NULL, NULL),
('sub_002', 'cust_002', 'plan_2', 'canceled', '2024-02-10', '2024-06-01', 'customer_request'),
('sub_003', 'cust_003', 'plan_3', 'active', '2024-03-15', NULL, NULL);

CREATE TABLE public.subscription_events (
    event_id TEXT,
    subscription_id TEXT,
    customer_id TEXT,
    event_type TEXT,
    plan_id TEXT,
    event_timestamp TIMESTAMP
);

INSERT INTO public.subscription_events VALUES
('evt_001', 'sub_001', 'cust_001', 'created', 'plan_1', '2024-01-05 10:00:00'),
('evt_002', 'sub_002', 'cust_002', 'created', 'plan_2', '2024-02-10 10:00:00'),
('evt_003', 'sub_002', 'cust_002', 'canceled', 'plan_2', '2024-06-01 10:00:00'),
('evt_004', 'sub_003', 'cust_003', 'created', 'plan_3', '2024-03-15 10:00:00');

CREATE TABLE public.invoices (
    invoice_id TEXT,
    subscription_id TEXT,
    customer_id TEXT,
    amount DOUBLE PRECISION,
    status TEXT,
    issued_date DATE,
    paid_date DATE
);

INSERT INTO public.invoices VALUES
('inv_001', 'sub_001', 'cust_001', 15.0, 'paid', '2024-04-01', '2024-04-02'),
('inv_002', 'sub_002', 'cust_002', 150.0, 'paid', '2024-03-01', '2024-03-02'),
('inv_003', 'sub_003', 'cust_003', 49.0, 'paid', '2024-04-01', '2024-04-02'),
('inv_004', 'sub_001', 'cust_001', 15.0, 'failed', '2024-05-01', NULL),
('inv_005', 'sub_002', 'cust_002', 150.0, 'refunded', '2024-05-01', '2024-05-02');

CREATE TABLE public.payment_events (
    payment_event_id TEXT,
    invoice_id TEXT,
    event_type TEXT,
    event_timestamp TIMESTAMP,
    _loaded_at TIMESTAMP
);

INSERT INTO public.payment_events VALUES
('pay_001', 'inv_001', 'payment_succeeded', '2024-04-02 12:00:00', '2024-04-02 12:05:00'),
('pay_002', 'inv_002', 'payment_succeeded', '2024-03-02 12:00:00', '2024-03-02 12:05:00'),
('pay_003', 'inv_003', 'payment_succeeded', '2024-04-02 12:00:00', '2024-04-02 12:05:00'),
('pay_004', 'inv_004', 'payment_failed', '2024-05-01 12:00:00', '2024-05-01 12:05:00'),
('pay_005', 'inv_005', 'payment_refunded', '2024-05-02 12:00:00', '2024-05-02 12:05:00');

CREATE TABLE public.support_tickets (
    ticket_id TEXT,
    customer_id TEXT,
    category TEXT,
    created_at TIMESTAMP,
    resolved_at TIMESTAMP
);

INSERT INTO public.support_tickets VALUES
('ticket_001', 'cust_001', 'billing', '2024-04-10 09:00:00', '2024-04-11 09:00:00'),
('ticket_002', 'cust_002', 'technical', '2024-04-15 10:00:00', '2024-04-16 10:00:00'),
('ticket_003', 'cust_003', 'billing', '2024-05-05 11:00:00', NULL);