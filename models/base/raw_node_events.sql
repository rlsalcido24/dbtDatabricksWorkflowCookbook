{{
    config(
        materialized = 'view'
    )
}}

select * from system.compute.node_timeline