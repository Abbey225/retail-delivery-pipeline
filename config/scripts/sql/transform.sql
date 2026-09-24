-- Phase 1: Construct Analytical Target Architecture
CREATE TABLE IF NOT EXISTS dim_customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(255),
    customer_email VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS fct_sales (
    sale_id SERIAL PRIMARY KEY,
    transaction_id VARCHAR(50),
    customer_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity INT,
    unit_price NUMERIC(10, 2),
    total_revenue NUMERIC(10, 2),
    purchased_at TIMESTAMP
);

-- Phase 2: Distinct Customer Normalization Step
INSERT INTO dim_customers (customer_id, customer_name, customer_email)
SELECT DISTINCT
    raw_data->'customer'->>'id' AS customer_id,
    raw_data->'customer'->>'name' AS customer_name,
    raw_data->'customer'->>'email' AS customer_email
FROM raw_transactions
ON CONFLICT (customer_id) DO NOTHING;

-- Phase 3: Array Denormalization to Populate Star Schema Fact Layers
INSERT INTO fct_sales (transaction_id, customer_id, product_id, quantity, unit_price, total_revenue, purchased_at)
SELECT 
    raw_data->>'transaction_id' AS transaction_id,
    raw_data->'customer'->>'id' AS customer_id,
    item->>'product_id' AS product_id,
    (item->>'qty')::INT AS quantity,
    (item->>'price')::NUMERIC(10,2) AS unit_price,
    ((item->>'qty')::INT * (item->>'price')::NUMERIC(10,2)) AS total_revenue,
    (raw_data->>'purchase_timestamp')::TIMESTAMP AS purchased_at
FROM raw_transactions,
LATERAL jsonb_array_elements(raw_data->'items') AS item;
