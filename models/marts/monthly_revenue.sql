{{
    config(
        materialized='table'
    )
}}

SELECT
    order_month_str AS order_month,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(amount), 2) AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_order_value,
    ROUND(SUM(amount) / COUNT(DISTINCT customer_id), 2) AS revenue_per_customer
FROM {{ ref('fct_orders') }}
GROUP BY order_month_str
ORDER BY order_month_str