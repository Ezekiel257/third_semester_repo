# E-commerce Data Pipeline Project.

## Overview

This project focuses on building a robust and efficient data pipeline for processing and analyzing e-commerce data. The pipeline leverages a combination of powerful tools:

* **PostgreSQL:**  Stores the raw e-commerce data, providing a reliable and structured foundation.
* **Apache Airflow:** Orchestrates the entire data processing workflow, ensuring tasks are executed in the correct order and dependencies are managed effectively.
* **Docker:** Containerizes both the PostgreSQL database and Airflow environment, guaranteeing consistency and portability across different development and production environments.
* **Google Cloud Storage (GCS):**  Provides a scalable and secure storage solution for data during the processing pipeline.
* **BigQuery:**  A powerful serverless data warehouse that enables efficient analysis and reporting on the processed e-commerce data.

This README.md serves as a comprehensive guide, outlining the project's structure, setup instructions, and key components.

## Table of Contents

1. **E-commerce Database Setup**
    * Database Schema
    * Data Loading
2. **Airflow Setup**
    * Installation
    * Configuration
3. **Docker Configuration**
    * Containerization
    * Docker Compose
4. **DAGs (Directed Acyclic Graphs)**
    * Workflow Definition
    * Tasks
5. **Data Migration**
    * ETL Process
    * Data Movement
6. **Additional Notes**
    * Error Handling
    * Scalability
    * Security

## E-commerce Database Setup

### Database Schema

The database schema is meticulously designed to accommodate a wide range of e-commerce data, including:

* **Customer Information:**  `olist_customers` table stores details like customer ID, unique ID, zip code, city, and state.
* **Orders:**  `olist_orders` table captures order information, including order ID, customer ID, order status, timestamps, delivery details, and more.
* **Order Items:**  `olist_order_items` table records details about individual items within each order, such as product ID, seller ID, shipping dates, price, and freight value.
* **Payments:**  `olist_order_payments` table stores payment details associated with each order, including payment type, installments, and value.
* **Reviews:**  `olist_order_reviews` table holds customer reviews for orders, including review ID, score, comments, and timestamps.
* **Products:**  `olist_products` table contains product details, such as product ID, category, name, description, photos quantity, weight, and dimensions.
* **Sellers:**  `olist_sellers` table stores seller information, including seller ID, zip code, city, and state.
* **Product Category Translations:**  `product_category_name_translation` table provides translations for product category names.
* **Geolocation Data:**  `olist_geolocation` table contains geolocation data for zip codes, including latitude, longitude, city, and state.

### Data Loading

The schema creation process involves defining tables with appropriate columns and constraints, followed by loading data from CSV files into these tables. This ensures that the data is structured correctly and ready for processing.

## Airflow Setup

### Installation

Apache Airflow is installed and configured to run within a Docker container, providing a consistent and isolated environment for managing the data pipeline.

### Configuration

Airflow is configured to connect to PostgreSQL for metadata storage and to Google Cloud for data transfer. Environment variables are used to manage sensitive information and configuration settings securely.

## Docker Configuration

### Containerization

Docker is used to create containers for both PostgreSQL and Airflow, ensuring consistent environments across different systems.

### Docker Compose

A `docker-compose.yml` file is used to define and manage the multi-container application, specifying the services, volumes, and networks required for the project.

## DAGs (Directed Acyclic Graphs)

### Workflow Definition

DAGs are used to define the workflow for data processing. Each DAG specifies tasks to be performed and their order of execution.

### Tasks

The DAGs include tasks for:

* **Data Extraction:**  Extracting data from PostgreSQL and saving it to Google Cloud Storage.
* **Data Loading:**  Loading data from Google Cloud Storage into BigQuery.

The DAGs are configured to handle errors, retries, and logging, ensuring robustness and reliability of the ETL process.

## Data Migration

### ETL Process

The ETL process involves moving data from PostgreSQL to BigQuery. This process includes:

* **Extraction:**  Extracting data from PostgreSQL tables and saving it in a suitable format (e.g., Parquet) to Google Cloud Storage.
* **Transformation:**  Data may be transformed during the extraction process to ensure it is in the correct format for loading into BigQuery.
* **Loading:**  Loading the transformed data from Google Cloud Storage into BigQuery tables for analysis and reporting.

### Data Movement

The data migration process is managed by Airflow DAGs, ensuring that the data is moved and transformed efficiently and accurately.

## Additional Notes

### Error Handling

Detailed error logging and handling are implemented to capture and address any issues that arise during the ETL process.

### Scalability

The setup is designed to be scalable, allowing for additional tables or data sources to be incorporated into the pipeline as needed.

### Security

Sensitive information, such as database credentials and API keys, is managed using environment variables and secure storage solutions.

## Getting Started

1. **Clone the repository:** `git clone [repository URL]`
2. **Install dependencies:** `pip install -r requirements.txt`
3. **Build Docker images:** `docker-compose build`
4. **Start the containers:** `docker-compose up -d`
5. **Run Airflow:** Access the Airflow web interface at `http://localhost:8080`
6. **Execute DAGs:** Trigger the DAGs within the Airflow web interface to initiate the data processing and migration.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is licensed under the MIT License.





