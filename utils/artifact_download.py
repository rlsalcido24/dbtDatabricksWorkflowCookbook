"""Call Databricks jobs endpoint to download artifacts.
   Example call: python get_output.py <run_task_id> <file_path.tar.gz>
"""

import requests
import sys
import os
import subprocess

run_id = sys.argv[1]
destination_path = sys.argv[2]
db_host = sys.argv[3]

destination_archive_file_name = destination_path + "/last_run_target.tar.gz"
destination_unzipped_path = destination_path + "/last_run"

print(run_id)
print(destination_path)
print(db_host)

db_token = os.getenv("DBT_DATABRICKS_TOKEN")

auth = ('token', db_token)
headers = {'Host': db_host, 'Content-Type': 'application/json'}

response = requests.get(f"{db_host}/api/2.1/jobs/runs/get-output?run_id={run_id}", auth=auth)
print(response.text)
if response.status_code != 200:
    raise ValueError(f"Error retrieving Databricks job run output. Full response: {response.text}")

results = response.json()
# print(results["metadata"])

artifacts_link=results["dbt_output"]["artifacts_link"]
print(artifacts_link)
artifacts_response = requests.get(artifacts_link, stream=True)
if artifacts_response.status_code == 200:
    with open(destination_archive_file_name, 'wb') as f:
        f.write(artifacts_response.raw.read())
    print(f"Output artifacts downloaded to {destination_archive_file_name}")
    print("Unzipping artifacts")
    subprocess.call(f"tar -xvf {destination_archive_file_name} -C {destination_unzipped_path}", shell=True)
    print(f"Artifacts available at last_run")
else:

    raise ValueError(f"Error downloading artifacts. Full response: {response.text}")