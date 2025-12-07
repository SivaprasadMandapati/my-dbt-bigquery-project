{{
    config(
        materialized='table'
    )
}}

WITH orders_with_customer AS (
    SELECT
        o.order_id,
        o.customer_id,
        c.email AS customer_email,
        c.first_name AS customer_first_name,
        c.last_name AS customer_last_name,
        o.order_date,
        o.status,
        o.amount,
        c.signup_date AS customer_signup_date,
        DATE_DIFF(o.order_date, c.signup_date, DAY) AS days_since_signup,
        EXTRACT(YEAR FROM o.order_date) AS order_year,
        EXTRACT(MONTH FROM o.order_date) AS order_month,
        FORMAT_DATE('%Y-%m', o.order_date) AS order_month_str
    FROM {{ ref('stg_orders') }} o
    LEFT JOIN {{ ref('stg_customers') }} c
        ON o.customer_id = c.customer_id
)

SELECT * FROM orders_with_customer