{{
    config(
        materialized = 'view'
    )
}}

select * from system.billing.usage