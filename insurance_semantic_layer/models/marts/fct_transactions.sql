{#
  Grain: one row per financial transaction on a policy.
  customer_id is denormalized from stg_policies for easy customer-level
  aggregation without joining back through policies.
#}

with

transactions as (

    select * from {{ ref('stg_transactions') }}

),

policies as (

    select
        policy_id,
        customer_id
    from {{ ref('stg_policies') }}

),

joined as (

    select
        t.transaction_id,
        t.policy_id,
        p.customer_id,

        t.transaction_type,
        t.transaction_status,

        t.transaction_date,
        t.transaction_amount,

        case
            when t.transaction_status = 'Completed' then true
            else false
        end as is_completed_transaction

    from transactions as t
    left join policies as p
        on t.policy_id = p.policy_id

)

select * from joined
