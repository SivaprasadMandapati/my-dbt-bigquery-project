{{
    config(
        materialized='table'
    )
}}

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(amount) AS lifetime_value,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,
        AVG(amount) AS avg_order_value
    FROM {{ ref('stg_orders') }}
    GROUP BY customer_id
),

customer_info AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.signup_date,
        COALESCE(o.total_orders, 0) AS total_orders,
        COALESCE(o.lifetime_value, 0) AS lifetime_value,
        ROUND(COALESCE(o.avg_order_value, 0), 2) AS avg_order_value,
        o.first_order_date,
        o.last_order_date,
        DATE_DIFF(o.last_order_date, o.first_order_date, DAY) AS customer_lifetime_days,
        DATE_DIFF(CURRENT_DATE(), o.last_order_date, DAY) AS days_since_last_order,
        CASE
            WHEN o.total_orders >= 3 THEN 'VIP'
            WHEN o.total_orders = 2 THEN 'Repeat'
            WHEN o.total_orders = 1 THEN 'One-time'
            ELSE 'Never Purchased'
        END AS customer_segment
    FROM {{ ref('stg_customers') }} c
    LEFT JOIN customer_orders o
        ON c.customer_id = o.customer_id
)

SELECT * FROM customer_info