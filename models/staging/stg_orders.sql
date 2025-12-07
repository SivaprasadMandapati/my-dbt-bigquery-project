{{config (
    materialized='view'
)}}

with source_data as (
    select * from {{ source('raw_data', 'raw_orders')}}
),

cleaned as (
    SELECT
        order_id,
        customer_id,
        order_date,
        LOWER(TRIM(status)) AS status,
        CAST(amount AS FLOAT64) AS amount,
        CURRENT_TIMESTAMP() AS dbt_loaded_at
    FROM source_data
    WHERE status != 'cancelled'  -- Filter out cancelled orders
)

select * from cleaned