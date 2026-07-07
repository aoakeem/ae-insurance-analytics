{# Grain: one row per policy. #}

with

policies as (

    select * from {{ ref('stg_policies') }}

),

final as (

    select
        policy_id,
        customer_id,

        policy_number,
        policy_type,
        policy_status,
        policy_start_date,

        coverage_amount,
        annual_premium_amount,

        case
            when policy_status = 'Active' then true
            else false
        end as is_active_policy

    from policies

)

select * from final
