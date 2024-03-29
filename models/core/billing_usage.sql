{{
    config(
        materialized = 'incremental',
        incremental_strategy='merge',
        unique_key='record_id',
        zorder_by= 'usage_end_time, usage_start_time',
        post_hook=[
        "ANALYZE TABLE {{ this }} COMPUTE STATISTICS FOR ALL COLUMNS;"
        ]
    )
}}
With usage_costs as (
select
  u.record_id,
  u.workspace_id,
  u.sku_name,
  u.usage_start_time,
  u.usage_end_time,
  u.usage_date,
  date_format(u.usage_date, 'yyyy-MM') as YearMonth,
  u.usage_unit,
  u.usage_quantity,
  lp.pricing.default as list_price,
  lp.pricing.default * u.usage_quantity as list_cost,
  case when  u.usage_metadata.job_id is not null then 'job'
       when  u.usage_metadata.dlt_pipeline_id is not null then 'dlt'
       when  u.usage_metadata.warehouse_id is not null then 'sql'
       when  u.usage_metadata.notebook_id is not null then 'notebook'
       else 'other' end as usage_type,
  coalesce(u.usage_metadata.job_id, u.usage_metadata.dlt_pipeline_id, u.usage_metadata.warehouse_id, u.usage_metadata.notebook_id) as resource_id,
  u.usage_metadata.*
from
  {{ ref('raw_billing_usage') }} u
  inner join system.billing.list_prices lp on u.cloud = lp.cloud and
    u.sku_name = lp.sku_name and
    u.usage_start_time >= lp.price_start_time and
    (u.usage_end_time <= lp.price_end_time or lp.price_end_time is null)

{% if is_incremental() %}
  where
     usage_end_time >= (select max(usage_end_time) from {{ this }})
{% endif %}
)
     select * from usage_costs