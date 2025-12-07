{{ config (
    materialized='view'
    
) }}

with source_data as (
    select * from {{ source('raw_data', 'raw_customers')}}
),

cleaned as (
    SELECT
        customer_id,
        LOWER(TRIM(first_name)) AS first_name,
        LOWER(TRIM(last_name)) AS last_name,
        LOWER(TRIM(email)) AS email,
        signup_date,
        CURRENT_TIMESTAMP() AS dbt_loaded_at
    FROM source_data
)

select * from cleaned