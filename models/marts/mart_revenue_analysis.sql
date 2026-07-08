with order_items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

translation as (
    select * from {{ ref('stg_product_category_translation') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

revenue_analysis as (
    select 
        p.product_id,
        t.product_category_name_english,
        c.state as customer_state,
        oi.price,
        o.order_status,
        o.purchased_at
    from products p
    inner join order_items oi on p.product_id = oi.product_id 
    left join translation t on p.product_category = t.product_category_name
    inner join orders o on oi.order_id = o.order_id
    inner join customers c on o.customer_id = c.customer_id
)

select * from revenue_analysis
