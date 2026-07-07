/*
  Semantic-layer equivalent:
      mf query --metrics average_time_to_claim_settlement
      mf query --metrics average_time_to_claim_settlement --group-by claim__claim_category
*/

with

settled_claims as (

    select *
    from {{ ref('fct_claims') }}
    where is_settled_claim = true

)

select
    coalesce(claim_category, 'ALL')                    as claim_category,
    count(*)                                           as settled_claim_count,
    round(avg(days_to_settlement), 1)                  as avg_days_to_settlement,
    min(days_to_settlement)                            as min_days_to_settlement,
    max(days_to_settlement)                            as max_days_to_settlement
from settled_claims
group by rollup(claim_category)
order by claim_category
