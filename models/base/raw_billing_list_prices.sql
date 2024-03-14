{{
    config(
        materialized = 'view'
    )
}}

select * from system.billing.list_prices