select *
from {{ ref('fct_mrr_movements') }}
where new_mrr < 0