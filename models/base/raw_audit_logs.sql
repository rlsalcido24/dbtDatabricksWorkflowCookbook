{{
    config(
        materialized = 'view'
    )
}}

select * from system.access.audit