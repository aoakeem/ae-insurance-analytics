/*
  Semantic-layer equivalent:
      mf query --metrics active_policies
      mf query --metrics active_policies --group-by policy__policy_type
*/

select
    coalesce(policy_type, 'ALL')  as policy_type,
    count(*)                      as active_policy_count
from {{ ref('fct_policies') }}
where is_active_policy = true
group by rollup(policy_type)
order by policy_type
