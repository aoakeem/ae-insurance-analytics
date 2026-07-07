with

source as (

    select * from {{ source('insurance', 'raw_claims_2hr') }}

),

renamed as (

    select
        cast(claim_id            as integer)        as claim_id,
        cast(policy_id           as integer)        as policy_id,

        cast(claim_number        as varchar)        as claim_number,
        cast(claim_category      as varchar)        as claim_category,
        cast(claim_status        as varchar)        as claim_status,

        cast(claim_amount        as decimal(18, 2)) as claim_amount,
        cast(settlement_amount   as decimal(18, 2)) as settlement_amount,

        cast(claim_date          as date)           as claim_date,
        cast(settlement_date     as date)           as settlement_date,

        cast(days_to_settlement  as integer)        as days_to_settlement

    from source

)

select * from renamed
