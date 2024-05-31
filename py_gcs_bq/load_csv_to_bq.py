from google.cloud import bigquery
import os
from google.api_core.exceptions import NotFound, BadRequest

# Load environment variables
from config import GCP_PROJECT_ID, GOOGLE_APPLICATION_CREDENTIALS

# Set up BigQuery client
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = GOOGLE_APPLICATION_CREDENTIALS
client = bigquery.Client(project=GCP_PROJECT_ID)

def create_dataset_if_not_exists(dataset_id):
    """
    Create a BigQuery dataset if it does not exist.

    Args:
        dataset_id (str): data-interaction-424913.etl_basics
    """
    dataset_ref = client.dataset(dataset_id)
    try:
        client.get_dataset(dataset_ref)
        print(f"Dataset {dataset_id} already exists.")
    except NotFound:
        dataset = bigquery.Dataset(dataset_ref)
        dataset.location = "EU"  # Set the dataset location to EU
        client.create_dataset(dataset)
        print(f"Created dataset {dataset_id}.")

def load_csv_to_bq(csv_path, dataset_id, table_id):
    """
    Load CSV data into a BigQuery table.

    Args:
        csv_path (str): C:\\Users\\HP\\Desktop\\altschool_project\\third_semester_repo\\py_gcs_bq\\data\\customers.csv"
        dataset_id (str): data-interaction-424913.etl_basics
        table_id (str): data-interaction-424913.etl_basics.ETL_Basics
    """
    # Ensure the dataset exists
    create_dataset_if_not_exists(dataset_id)

    dataset_ref = client.dataset(dataset_id)
    table_ref = dataset_ref.table(table_id)

    # Check if the table exists
    try:
        table = client.get_table(table_ref)
        print(f"Table {dataset_id}.{table_id} already exists.")
    except NotFound:
        table = bigquery.Table(table_ref)
        client.create_table(table)
        print(f"Created table {dataset_id}.{table_id}.")

    # Configure the load job
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        skip_leading_rows=1,
        autodetect=True,  # Let BigQuery infer the schema
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,  # Truncate the table before loading
    )

    # Load CSV into BigQuery
    try:
        with open(csv_path, "rb") as source_file:
            job = client.load_table_from_file(source_file, table_ref, job_config=job_config)
        job.result()  # Waits for the job to complete
        print(f"Loaded {job.output_rows} rows into {dataset_id}.{table_id}.")
    except Exception as e:
        print(f"Failed to load CSV into BigQuery: {e}")

# Usage
try:
    load_csv_to_bq(
        r"C:\Users\HP\Desktop\altschool_project\third_semester_repo\py_gcs_bq\data\customers.csv",  # Replace with your CSV file path
        "etl_basics",  # Replace with your dataset ID
        "ETL_Basics"  # Replace with your table name
    )
except Exception as e:
    print(f"An error occurred: {e}")
