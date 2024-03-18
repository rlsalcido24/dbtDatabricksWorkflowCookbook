select
    usage_type, resource_id, sku_name,
    cast(usage_date as date) as usage_date, sum(usage_quantity) as quantity, sum(list_cost) as cost
from {{ ref('billing_usage') }} u
group by all
