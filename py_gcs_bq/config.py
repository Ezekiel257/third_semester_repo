from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

# Retrieve environment variables
GCP_PROJECT_ID = os.getenv("GCP_PROJECT_ID")
GCS_BUCKET_NAME = os.getenv("GCS_BUCKET_NAME")
GOOGLE_APPLICATION_CREDENTIALS = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
API_URL = os.getenv("API_URL")
schema = os.getenv("schema")

# Ensure paths are converted to raw string literals

# Use raw string literals for file paths
if GOOGLE_APPLICATION_CREDENTIALS:
    GOOGLE_APPLICATION_CREDENTIALS = os.path.realpath(GOOGLE_APPLICATION_CREDENTIALS)

# Ensure paths are converted to raw string literals
if hasattr(os, 'addbslashes'):
    GCS_BUCKET_NAME = os.addbslashes(GCS_BUCKET_NAME)
    GOOGLE_APPLICATION_CREDENTIALS = os.addbslashes(GOOGLE_APPLICATION_CREDENTIALS)

