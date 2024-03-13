# dbt Databricks Workflow Cookbook
---
This content contains examples of using dbt with Databricks to track history and build aggregates based on Databricks System Tables. It can be used to test how Databricks can run dbt for SQL Models, including running as tasks within a Databricks Workflow. The included workflows includes some commmon needs such as storing the dbt artifacts to be used in the next run.


### Project structure

This example repo has a few key directories. View each object/sub-folder mentioned below for more detail.
    
- ```dbt_project.yml```
    * Every dbt project requires a ```dbt_project.yml``` file - this is how dbt knows a directory is a dbt project
    * It contains information such as connection configurations to Databricks SQL Warehouses and where SQL transformation files are stored 

- ```profiles.yml```
    * This file stores profile configuration which dbt needs to connect to Databricks compute resources
    * Connection details such as the server hostname, HTTP path, catalog, db/schema information are configured here 
    
- ```models```
    * A model in dbt refers to a single ```.sql``` or ```.py``` file containing a modular data transformation block 
    * In this repo, we have modularized our transformations into bronze, silver, gold files in line with the Medallion Architecture 
    * Within each file, we can configure how the transformation will be materialized - either as a table, view, incremental, streaming_table, or materialized_view. Default will be table.

- ```tests```
    * Tests are assertions you make about your dbt models 
    * They are typically used for data quality and validation purposes
    * We also have the ability to quarantine and isolate records that fail a particular assertion

<br>
