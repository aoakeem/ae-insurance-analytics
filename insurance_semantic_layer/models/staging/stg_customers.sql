with

source as (

    select * from {{ source('insurance', 'raw_customers_2hr') }}

),

renamed as (

    select
        cast(customer_id       as integer) as customer_id,
        cast(customer_name     as varchar) as customer_name,
        cast(state             as varchar) as state_code,
        cast(age               as integer) as age,
        cast(customer_segment  as varchar) as customer_segment

    from source

)

select * from renamed
