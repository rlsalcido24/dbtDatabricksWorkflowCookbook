{{
    config(
        materialized = 'view'
    )
}}

select * from system.compute.clusters