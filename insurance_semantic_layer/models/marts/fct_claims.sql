{#
  Grain: one row per claim (transactional fact).
  customer_id is denormalized from stg_policies so analysts can slice claims by
  customer attributes without a two-hop join.
#}

with

claims as (

    select * from {{ ref('stg_claims') }}

),

policies as (

    select
        policy_id,
        customer_id
    from {{ ref('stg_policies') }}

),

joined as (

    select
        c.claim_id,
        c.policy_id,
        p.customer_id,

        c.claim_number,
        c.claim_category,
        c.claim_status,

        c.claim_date,
        c.settlement_date,

        c.claim_amount,
        c.settlement_amount,
        c.days_to_settlement,

        case
            when c.claim_status = 'Settled' then true
            else false
        end as is_settled_claim

    from claims as c
    left join policies as p
        on c.policy_id = p.policy_id

)

select * from joined
