with customer_orders as (
    select * from {{ ref('mart_customer_orders') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

cohort_retention as (
    select 
        c.customer_id,
        c.first_order_date,
        o.purchased_at,
        DATE_TRUNC('month', first_order_date) as cohort_month,
        DATEDIFF('month', first_order_date, purchased_at) as month_index
    from customer_orders c
    left join orders o on c.customer_id = o.customer_id
),

final as (
    select 
        COUNT(DISTINCT customer_id) as count_of_customers,
        cohort_month,
        month_index
    from cohort_retention
    where month_index >= 0
    group by cohort_month, month_index

)

select * from final
