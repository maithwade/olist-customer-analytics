with source as (
    select * from {{ source('raw', 'marketing_leads') }}
),

renamed as (
    select
        mql_id,
        first_contact_date as contacted_at,
        landing_page_id,
        origin
        
    from source
)

select * from renamed
