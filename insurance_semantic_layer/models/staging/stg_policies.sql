with

source as (

    select * from {{ source('insurance', 'raw_policies_2hr') }}

),

renamed as (

    select
        cast(policy_id          as integer)        as policy_id,
        cast(customer_id        as integer)        as customer_id,

        cast(policy_number      as varchar)        as policy_number,
        cast(policy_type        as varchar)        as policy_type,
        cast(policy_status      as varchar)        as policy_status,

        cast(coverage_amount    as decimal(18, 2)) as coverage_amount,
        cast(annual_premium     as decimal(18, 2)) as annual_premium_amount,

        cast(policy_start_date  as date)           as policy_start_date

    from source

)

select * from renamed
