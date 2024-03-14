{{
    config(
        materialized = 'view'
    )
}}

select * from system.query.history