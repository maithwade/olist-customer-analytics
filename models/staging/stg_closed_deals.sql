with source as (
    select * from {{ source('raw', 'closed_deals') }}
),

renamed as (
    select
        mql_id,
        seller_id,
        sdr_id,
        sr_id,
        won_date as closed_date,
        business_segment,
        lead_type,
        lead_behaviour_profile as lead_profile,
        has_company,
        has_gtin,
        average_stock,
        business_type,
        declared_product_catalog_size as catalog_size,
        declared_monthly_revenue as monthly_revenue
        
    from source
)

select * from renamed
