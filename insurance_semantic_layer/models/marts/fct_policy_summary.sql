{#
  Grain: one row per policy.
  Rolls up claims and transactions per policy to avoid fan-out on joins.
  See _marts__models.yml and README for full rationale.
#}

with

policies as (

    select * from {{ ref('fct_policies') }}

),

customers as (

    select * from {{ ref('dim_customers') }}

),

claims_agg as (

    select
        policy_id,
        count(*)                                                as claim_count,
        sum(claim_amount)                                       as total_claim_amount,
        sum(case when is_settled_claim then settlement_amount else 0 end) as total_settlement_paid,
        sum(case when is_settled_claim then 1 else 0 end)       as settled_claim_count
    from {{ ref('fct_claims') }}
    group by policy_id

),

transactions_agg as (

    select
        policy_id,
        sum(case when transaction_type   = 'Premium Payment'
                  and transaction_status = 'Completed'
                 then transaction_amount else 0 end)            as total_premium_paid,
        sum(case when transaction_type   = 'Adjustment'
                  and transaction_status = 'Completed'
                 then transaction_amount else 0 end)            as total_premium_adjustments,
        sum(case when transaction_status = 'Completed'
                 then transaction_amount else 0 end)            as total_net_premium_collected,
        count(*)                                                as transaction_count
    from {{ ref('fct_transactions') }}
    group by policy_id

),

final as (

    select
        -- Keys
        p.policy_id,
        p.customer_id,

        -- Policy attributes
        p.policy_number,
        p.policy_type,
        p.policy_status,
        p.policy_start_date,
        p.is_active_policy,

        -- Customer attributes (denormalized)
        c.state_code,
        c.customer_segment,
        c.age_band,

        -- Policy-level measures
        p.coverage_amount,
        p.annual_premium_amount,

        -- Rolled-up transaction measures
        coalesce(ta.total_premium_paid, 0)          as total_premium_paid,
        coalesce(ta.total_premium_adjustments, 0)   as total_premium_adjustments,
        coalesce(ta.total_net_premium_collected, 0) as total_net_premium_collected,
        coalesce(ta.transaction_count, 0)           as transaction_count,

        -- Rolled-up claim measures
        coalesce(ca.claim_count, 0)                 as claim_count,
        coalesce(ca.settled_claim_count, 0)         as settled_claim_count,
        coalesce(ca.total_claim_amount, 0)          as total_claim_amount,
        coalesce(ca.total_settlement_paid, 0)       as total_settlement_paid

    from policies as p
    left join customers        as c  on p.customer_id = c.customer_id
    left join claims_agg       as ca on p.policy_id  = ca.policy_id
    left join transactions_agg as ta on p.policy_id  = ta.policy_id

)

select * from final
