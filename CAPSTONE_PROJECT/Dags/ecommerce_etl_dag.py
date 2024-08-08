import os
import logging
from datetime import timedelta
from airflow import DAG
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from airflow.operators.python_operator import PythonOperator
from airflow.hooks.postgres_hook import PostgresHook
from airflow.utils.dates import days_ago
from dotenv import load_dotenv
import psycopg2
from sqlalchemy import create_engine

# Load environment variables from .env file
load_dotenv()

# Environment variables
POSTGRES_DB = os.getenv('POSTGRES_DB')
POSTGRES_USER = os.getenv('POSTGRES_USER')
POSTGRES_PASSWORD = os.getenv('POSTGRES_PASSWORD')
POSTGRES_PORT = os.getenv('POSTGRES_PORT')
GCP_PROJECT_ID = os.getenv('GCP_PROJECT_ID')
GCS_BUCKET = os.getenv('GCS_BUCKET')
GCS_KEYFILE_PATH = os.getenv('GCS_KEYFILE_PATH')
BIGQUERY_DATASET = os.getenv('BIGQUERY_DATASET')
BIGQUERY_TABLE_PREFIX = os.getenv('BIGQUERY_TABLE_PREFIX', 'ecommerce')

# SQLAlchemy connection string
SQLALCHEMY_CONN_STRING = f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@postgres_db:{POSTGRES_PORT}/{POSTGRES_DB}"

# List of tables to move
tables = [
    'olist_geolocation',
    'product_category_name_translation',
    'olist_sellers',
    'olist_products',
    'olist_order_reviews',
    'olist_order_payments',
    'olist_order_items',
    'olist_orders',
    'olist_customers'
]

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': days_ago(1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

def log_error(context):
    """
    Logs detailed error information when a task fails.
    """
    dag_run = context.get('dag_run')
    task_instance = context.get('task_instance')
    exception = context.get('exception')
    logger.error(f"Error in DAG: {dag_run.dag_id}, Task: {task_instance.task_id}")
    logger.error(f"Exception: {exception}")

def check_table_exists(table_name):
    """
    Checks if a table exists in the PostgreSQL database.
    Tries using both the Airflow connection, SQLAlchemy, and a direct connection string.
    """
    try:
        # Attempt to use the Airflow connection
        hook = PostgresHook(
            postgres_conn_id='postgres_default',
            schema=POSTGRES_DB
        )
        conn = hook.get_conn()
        cursor = conn.cursor()
        cursor.execute(f"SELECT to_regclass('public.{table_name}');")
        result = cursor.fetchone()
        if result[0] is None:
            raise ValueError(f"Table public.{table_name} does not exist using Airflow connection")
        logger.info(f"Table public.{table_name} exists using Airflow connection.")
    except Exception as e:
        logger.error(f"Failed to check table using Airflow connection: {e}")
        try:
            # Fallback to using SQLAlchemy connection
            engine = create_engine(SQLALCHEMY_CONN_STRING)
            with engine.connect() as conn:
                result = conn.execute(f"SELECT to_regclass('public.{table_name}');").fetchone()
                if result[0] is None:
                    raise ValueError(f"Table public.{table_name} does not exist using SQLAlchemy connection")
                logger.info(f"Table public.{table_name} exists using SQLAlchemy connection.")
        except Exception as e:
            logger.error(f"Failed to check table using SQLAlchemy connection: {e}")
            try:
                # Fallback to using the direct connection string
                conn = psycopg2.connect(
                    dbname=POSTGRES_DB,
                    user=POSTGRES_USER,
                    password=POSTGRES_PASSWORD,
                    host='postgres_db',
                    port=POSTGRES_PORT
                )
                cursor = conn.cursor()
                cursor.execute(f"SELECT to_regclass('public.{table_name}');")
                result = cursor.fetchone()
                if result[0] is None:
                    raise ValueError(f"Table public.{table_name} does not exist using direct connection string")
                logger.info(f"Table public.{table_name} exists using direct connection string.")
            except Exception as e:
                logger.error(f"Failed to check table using direct connection string: {e}")
                raise

def postgres_to_gcs_fallback(table, gcs_filename):
    """
    Extracts data from PostgreSQL and uploads it to Google Cloud Storage.
    Tries using both the Airflow connection, SQLAlchemy, and a direct connection string.
    """
    try:
        # Attempt to use the Airflow connection
        hook = PostgresHook(
            postgres_conn_id='postgres_default',
            schema=POSTGRES_DB
        )
        hook.copy_expert(f"COPY (SELECT * FROM public.{table}) TO STDOUT WITH (FORMAT parquet)", gcs_filename)
        logger.info(f"Data from table {table} exported to GCS using Airflow connection.")
    except Exception as e:
        logger.error(f"Failed to export data using Airflow connection: {e}")
        try:
            # Fallback to using SQLAlchemy connection
            engine = create_engine(SQLALCHEMY_CONN_STRING)
            with engine.connect() as conn:
                with open(gcs_filename, 'wb') as f:
                    conn.connection.cursor().copy_expert(f"COPY (SELECT * FROM public.{table}) TO STDOUT WITH (FORMAT parquet)", f)
                logger.info(f"Data from table {table} exported to GCS using SQLAlchemy connection.")
        except Exception as e:
            logger.error(f"Failed to export data using SQLAlchemy connection: {e}")
            try:
                # Fallback to using the direct connection string
                conn = psycopg2.connect(
                    dbname=POSTGRES_DB,
                    user=POSTGRES_USER,
                    password=POSTGRES_PASSWORD,
                    host='postgres_db',  # Adjust if hosted elsewhere
                    port=POSTGRES_PORT
                )
                cursor = conn.cursor()
                with open(gcs_filename, 'wb') as f:
                    cursor.copy_expert(f"COPY (SELECT * FROM public.{table}) TO STDOUT WITH (FORMAT parquet)", f)
                logger.info(f"Data from table {table} exported to GCS using direct connection string.")
            except Exception as e:
                logger.error(f"Failed to export data using direct connection string: {e}")
                raise

# Define the DAG
with DAG(
    'postgres_to_bigquery_multiple_tables',
    default_args=default_args,
    description='ETL DAG: Extract data from PostgreSQL and load it into BigQuery for multiple tables',
    schedule_interval='@daily',
    catchup=False,
) as dag:

    # Loop through each table and create tasks
    for table in tables:
        extract_task_id = f'extract_data_{table}'
        load_task_id = f'load_data_{table}'
        check_task_id = f'check_table_exists_{table}'
        gcs_filename = f'data/{table}_{{{{ ds }}}}.parquet'
        bq_table = f'{BIGQUERY_DATASET}.{BIGQUERY_TABLE_PREFIX}_{table}'

        try:
            # Task to check if the table exists
            check_table_task = PythonOperator(
                task_id=check_task_id,
                python_callable=check_table_exists,
                op_args=[table],
                on_failure_callback=log_error,
                retries=3,
                retry_delay=timedelta(minutes=5),
            )

            # Extract data from PostgreSQL and upload it to Google Cloud Storage
            extract_data = PythonOperator(
                task_id=extract_task_id,
                python_callable=postgres_to_gcs_fallback,
                op_args=[table, gcs_filename],
                on_failure_callback=log_error,
                retries=3,
                retry_delay=timedelta(minutes=5),
            )

            # Load data from Google Cloud Storage to BigQuery
            load_data = GCSToBigQueryOperator(
                task_id=load_task_id,
                bucket=GCS_BUCKET,
                source_objects=[gcs_filename],
                destination_project_dataset_table=bq_table,
                schema_fields=[],  # Define your schema fields here if needed
                source_format='PARQUET',
                write_disposition='WRITE_TRUNCATE',
                create_disposition='CREATE_IF_NEEDED',
                autodetect=True,  # Ensure autodetect is set to true to infer schema automatically
                on_failure_callback=log_error,
                retries=3,
                retry_delay=timedelta(minutes=5),
            )

            # Set task dependencies
            check_table_task >> extract_data >> load_data
        
        except Exception as e:
            logger.error(f"Failed to create tasks for table: {table}")
            logger.error(str(e))
