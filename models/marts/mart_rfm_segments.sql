with customer_orders as (
    select * from {{ ref('mart_customer_orders') }}
),

rfm_scores as (
    select  
        customer_id,
        customer_unique_id,
        city,
        state,
        total_orders,
        total_spent,
        first_order_date,
        last_order_date,
        DATEDIFF('day', last_order_date, CURRENT_DATE()) as recency_days,
        NTILE(5) OVER (ORDER BY last_order_date DESC) as recency_score,
        NTILE(5) OVER (ORDER BY total_orders ASC) as frequency_score,
        NTILE(5) OVER (ORDER BY total_spent ASC) AS monetary_score
    from customer_orders 
),

rfm_segments as (
    select *,
        recency_score + frequency_score + monetary_score as rfm_combined,
        CASE 
            WHEN recency_score >= 4 and frequency_score >= 4 and monetary_score >= 4 THEN 'Champion'
            WHEN recency_score >= 3 and frequency_score >= 3 THEN 'Loyal'
            WHEN recency_score >= 4 and frequency_score <= 2 THEN 'Promising'
            WHEN recency_score <= 2 and frequency_score >= 3 THEN 'At Risk'
            WHEN recency_score <= 2 and frequency_score <= 2 THEN 'Lost'
            ELSE 'Needs Attention'
        END as customer_segment
    FROM rfm_scores
)

select * from rfm_segments
