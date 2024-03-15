"""Call Databricks jobs endpoint to download artifacts.
   Example call: python get_output.py <run_task_id> <file_path.tar.gz>
"""

import requests
import sys
import os

run_id = sys.argv[1]
destination_path = sys.argv[2]
db_host = sys.argv[3]
db_token = os.getenv("DBT_DATABRICKS_TOKEN")

auth = ('token', db_token)
headers = {'Host': db_host, 'Content-Type': 'application/json'}

response = requests.get(f"{db_host}/api/2.1/jobs/runs/get-output?run_id={run_id}", auth=auth)
if response.status_code != 200:
    raise ValueError(f"Error retrieving Databricks job run output. Full response: {response.text}")

results = response.json()
# print(results["metadata"])

artifacts_link=results["dbt_output"]["artifacts_link"]

artifacts_response = requests.get(artifacts_link, stream=True)
if artifacts_response.status_code == 200:
    with open(destination_path, 'wb') as f:
        f.write(artifacts_response.raw.read())
    print(f"Output artifacts downloaded to {destination_path}")
else:

    raise ValueError(f"Error downloading artifacts. Full response: {response.text}")