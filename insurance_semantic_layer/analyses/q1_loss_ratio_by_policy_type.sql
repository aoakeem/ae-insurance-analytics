/*
  Claims are aggregated to policy grain first before joining to policies.
  A direct join would fan out and inflate the premium denominator.
  MetricFlow handles this automatically:
      mf query --metrics loss_ratio --group-by policy__policy_type
*/

with

settlements_by_policy as (

    select
        policy_id,
        sum(settlement_amount) as total_settlement
    from {{ ref('fct_claims') }}
    where is_settled_claim = true
    group by policy_id

)

select
    p.policy_type,
    count(*)                                                 as policy_count,
    sum(p.annual_premium_amount)                             as total_annual_premium,
    coalesce(sum(s.total_settlement), 0)                     as total_settlement_paid,
    coalesce(sum(s.total_settlement), 0)
        / nullif(sum(p.annual_premium_amount), 0)            as loss_ratio
from {{ ref('fct_policies') }} as p
left join settlements_by_policy as s on p.policy_id = s.policy_id
group by p.policy_type
order by loss_ratio desc
