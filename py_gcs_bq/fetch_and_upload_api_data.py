import requests
from google.cloud import storage, bigquery
from google.oauth2 import service_account
import json
import os
from config import GCP_PROJECT_ID, GCS_BUCKET_NAME, API_URL, GOOGLE_APPLICATION_CREDENTIALS
from io import StringIO

# Initialize clients for Google Cloud Storage and BigQuery
credentials = service_account.Credentials.from_service_account_file(GOOGLE_APPLICATION_CREDENTIALS)
storage_client = storage.Client(credentials=credentials, project=GCP_PROJECT_ID)
bigquery_client = bigquery.Client(credentials=credentials, project=GCP_PROJECT_ID)

def fetch_data_from_api(api_url):
    response = requests.get(api_url)
    print(f"API response status code: {response.status_code}")
    print(f"API response content type: {response.headers.get('content-type')}")
    if response.status_code == 200:
        if 'application/json' in response.headers.get('content-type'):
            data = response.json()
            return data
        else:
            print("Unknown response content type. Unable to process.")
    else:
        print("No data fetched. Exiting...")
    return None

def upload_to_gcs(bucket_name, destination_blob_name, data):
    """
    Upload data to a Google Cloud Storage bucket.

    Args:
        bucket_name (str): alschool_assignment
        destination_blob_name (str): data/data.json
        data (list): Data to be uploaded.
    """
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)
    # Upload the data as a JSON string
    blob.upload_from_string(json.dumps(data))
    print(f"Uploaded data to {bucket_name}/{destination_blob_name}")

def convert_to_jsonlines(data):
    """
    Convert a list of JSON objects to JSON Lines format.

    Args:
        data (list): List of JSON objects.

    Returns:
        str: Data in JSON Lines format.
    """
    jsonlines_data = "\n".join([json.dumps(record) for record in data])
    return jsonlines_data

def load_jsonlines_to_bq(jsonlines_data, dataset_id, table_id, schema_path):
    """
    Load JSON Lines data to a BigQuery table.

    Args:
        jsonlines_data (str): jsonlines_data
        dataset_id (str): data-interaction-424913.etl_basics
        table_id (str): data-interaction-424913.etl_basics.ETL_Basics
        schema_path (str): py_gcs_bq\schema\playstation_games_schema.json
    """
    dataset_ref = bigquery_client.dataset(dataset_id)
    table_ref = dataset_ref.table(table_id)
    
    # Load the schema from the JSON file
    with open(schema_path) as schema_file:
        schema = json.load(schema_file)

    try:
        bigquery_client.get_table(table_ref)
        table_exists = True
        print(f"Table {dataset_id}.{table_id} already exists.")
    except Exception:
        table_exists = False

    if not table_exists:
        table = bigquery.Table(table_ref, schema=schema)
        bigquery_client.create_table(table)
        print(f"Created table {dataset_id}.{table_id}.")

    job_config = bigquery.LoadJobConfig(
        schema=schema,
        source_format=bigquery.SourceFormat.NEWLINE_DELIMITED_JSON,
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE  # Ensure idempotency by overwriting the table
    )

    jsonlines_io = StringIO(jsonlines_data)

    job = bigquery_client.load_table_from_file(
        jsonlines_io, table_ref, job_config=job_config
    )
    job.result()
    print(f"Loaded {job.output_rows} rows into {dataset_id}:{table_id}.")

def main():
    try:
        # Fetch data from the API
        data = fetch_data_from_api(API_URL)
        if data:
            # Define the GCS bucket name and destination blob name
            bucket_name = GCS_BUCKET_NAME
            destination_blob_name = "data/data.json"  # Example path within the bucket
            
            # Upload the fetched data to Google Cloud Storage
            upload_to_gcs(bucket_name, destination_blob_name, data)
            
            # Convert the data to JSON Lines format
            jsonlines_data = convert_to_jsonlines(data)
            
            # Load the JSON Lines data into BigQuery
            schema_path = r"C:\Users\HP\Desktop\altschool_project\third_semester_repo\py_gcs_bq\schema\playstation_games_schema.json" # Adjust the path as necessary
            load_jsonlines_to_bq(jsonlines_data, "etl_basics", "playstation_games", schema_path)
            
            print("Data processing and upload completed successfully.")
        else:
            print("No data fetched. Exiting...")
    
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
