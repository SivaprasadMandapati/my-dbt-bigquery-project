{{
    config(
        materialized='table'
    )
}}

WITH customer_order_dates AS (
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
        DATE_DIFF(
            order_date,
            LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date),
            DAY
        ) AS days_between_orders
    FROM {{ ref('stg_orders') }}
),

retention_metrics AS (
    SELECT
        customer_id,
        COUNT(*) AS total_orders,
        AVG(days_between_orders) AS avg_days_between_orders,
        MIN(days_between_orders) AS min_days_between_orders,
        MAX(days_between_orders) AS max_days_between_orders,
        CASE 
            WHEN AVG(days_between_orders) IS NULL THEN 'Single Order'
            WHEN AVG(days_between_orders) <= 30 THEN 'Highly Engaged'
            WHEN AVG(days_between_orders) <= 60 THEN 'Regular'
            ELSE 'At Risk'
        END AS retention_segment
    FROM customer_order_dates
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.email,
    c.customer_segment,
    r.total_orders,
    ROUND(r.avg_days_between_orders, 1) AS avg_days_between_orders,
    r.retention_segment
FROM {{ ref('dim_customers') }} c
LEFT JOIN retention_metrics r
    ON c.customer_id = r.customer_id
WHERE c.total_orders > 0  -- Only customers who have ordered