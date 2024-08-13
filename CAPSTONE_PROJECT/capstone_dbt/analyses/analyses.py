import os
import json
from google.cloud import bigquery

# Set the environment variable for Google Application Credentials
GCS_KEYFILE_PATH = 'C:/Users/HP/Desktop/altschool_project/third_semester_repo/CAPSTONE_PROJECT/capstone-project-429612-d694bc2fcd86.json'
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = GCS_KEYFILE_PATH

# Initialize a BigQuery client
client = bigquery.Client()

# Path to the analyses directory
analyses_path = 'capstone_dbt/analyses'
output_path = 'capstone_dbt/snapshots'  # Folder to save the results

# Create the snapshot directory if it doesn't exist
if not os.path.exists(output_path):
    os.makedirs(output_path)

# Loop through each SQL file in the analyses directory
for file_name in os.listdir(analyses_path):
    if file_name.endswith('.sql'):
        # Read the SQL query from the file
        with open(os.path.join(analyses_path, file_name), 'r') as file:
            query = file.read()

        # Execute the query
        job = client.query(query)

        # Wait for the query to finish
        results = job.result()

        # Save results to a JSON file
        result_file_path = os.path.join(output_path, f'{os.path.splitext(file_name)[0]}.json')
        with open(result_file_path, 'w') as result_file:
            rows = [dict(row) for row in results]  # Convert rows to a list of dictionaries
            json.dump(rows, result_file, indent=4)  # Write the results to the JSON file

        print(f'Finished running analysis: {file_name}, results saved to {result_file_path}')
