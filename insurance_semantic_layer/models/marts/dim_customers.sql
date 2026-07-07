with

customers as (

    select * from {{ ref('stg_customers') }}

),

final as (

    select
        customer_id,
        customer_name,
        state_code,
        age,

        case
            when age <  30 then '18-29'
            when age <  45 then '30-44'
            when age <  60 then '45-59'
            when age >= 60 then '60+'
            else 'Unknown'
        end as age_band,

        customer_segment

    from customers

)

select * from final
