/*
  Bonus: Customer 360 view — policy, claim, and transaction totals per customer.
*/

with

customers as (

    select * from {{ ref('dim_customers') }}

),

policies_agg as (

    select
        customer_id,
        count(*)                              as policy_count,
        sum(annual_premium_amount)            as total_annual_premium,
        sum(coverage_amount)                  as total_coverage,
        sum(case when is_active_policy = true then 1 else 0 end) as active_policy_count
    from {{ ref('fct_policies') }}
    group by customer_id

),

claims_agg as (

    select
        customer_id,
        count(*)                              as claim_count,
        sum(claim_amount)                     as total_claim_amount,
        sum(settlement_amount)                as total_settlement_paid
    from {{ ref('fct_claims') }}
    group by customer_id

),

transactions_agg as (

    select
        customer_id,
        count(*)                              as transaction_count,
        sum(transaction_amount)               as total_transaction_amount
    from {{ ref('fct_transactions') }}
    group by customer_id

)

select
    c.customer_id,
    c.customer_name,
    c.state_code,
    c.customer_segment,
    c.age_band,

    coalesce(p.policy_count, 0)               as policy_count,
    coalesce(p.active_policy_count, 0)        as active_policy_count,
    coalesce(p.total_annual_premium, 0)       as total_annual_premium,
    coalesce(p.total_coverage, 0)             as total_coverage,

    coalesce(cl.claim_count, 0)               as claim_count,
    coalesce(cl.total_claim_amount, 0)        as total_claim_amount,
    coalesce(cl.total_settlement_paid, 0)     as total_settlement_paid,

    coalesce(t.transaction_count, 0)          as transaction_count,
    coalesce(t.total_transaction_amount, 0)   as total_transaction_amount,

    coalesce(cl.total_settlement_paid, 0)
        / nullif(p.total_annual_premium, 0)   as customer_loss_ratio

from customers as c
left join policies_agg     as p  on c.customer_id = p.customer_id
left join claims_agg       as cl on c.customer_id = cl.customer_id
left join transactions_agg as t  on c.customer_id = t.customer_id
order by customer_loss_ratio desc nulls last
