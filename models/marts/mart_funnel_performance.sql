with marketing_leads as (
    select * from {{ ref('stg_marketing_leads') }}
),

closed_deals as (
    select * from {{ ref('stg_closed_deals') }}
),

order_items as (
    select * from {{ ref('stg_order_items')}}
),

funnel_performance as (
    select 
        m.mql_id,
        m.origin,
        m.contacted_at,
        CASE WHEN c.mql_id IS NOT NULL THEN 'Yes' ELSE 'No' END as converted,
        c.closed_date,
        c.business_segment,
        SUM(o.price) as total_revenue
    from marketing_leads m 
    left join closed_deals c on m.mql_id = c.mql_id
    left join order_items o on c.seller_id = o.seller_id 
    group by m.mql_id, m.origin, m.contacted_at, converted, c.closed_date, c.business_segment
),

final as (
    select
        *,
        CASE 
            WHEN total_revenue IS NOT NULL 
            THEN total_revenue 
            ELSE 0 
        END as revenue_generated,
        DATEDIFF('day', contacted_at, closed_date) as days_to_close
    from funnel_performance
)

select * from final
