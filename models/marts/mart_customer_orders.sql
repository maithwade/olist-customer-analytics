with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select * from {{ ref('stg_order_payments')}}
),

final as (
    select  
        c.customer_id,
        c.customer_unique_id,
        c.city,
        c.state,
        COUNT(o.order_id) as total_orders,
        SUM(p.payment_value) as total_spent,
        MIN(o.approved_at) as first_order_date,
        MAX(o.approved_at) as last_order_date
    from customers c
    join orders o on c.customer_id = o.customer_id
    join payments p on o.order_id = p.order_id
    group by c.customer_id, c.customer_unique_id, c.city, c.state
),

final_with_ltv as (
    select 
        *, 
        total_spent / nullif(total_orders, 0) as avg_order_value,
        datediff('day', first_order_date, last_order_date) as customer_lifespan_days,
        total_spent as ltv
    from final
)

select * from final_with_ltv
