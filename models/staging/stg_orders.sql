with source as (
    select * from {{ source('raw', 'orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp as purchased_at,
        order_approved_at as approved_at,
        order_delivered_carrier_date as carrier_date,
        order_delivered_customer_date as customer_date,
        order_estimated_delivery_date as estimated_delivery_date
    from source
)

select * from renamed
