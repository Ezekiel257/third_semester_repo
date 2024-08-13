# E-commerce Data Pipeline Project

## Overview

This project focuses on building a robust and efficient data pipeline for processing and analyzing e-commerce data. The pipeline leverages a combination of powerful tools:

* **PostgreSQL:** Stores the raw e-commerce data, providing a reliable and structured foundation.
* **Apache Airflow:** Orchestrates the entire data processing workflow, ensuring tasks are executed in the correct order and dependencies are managed effectively.
* **Docker:** Containerizes both the PostgreSQL database and Airflow environment, guaranteeing consistency and portability across different development and production environments.
* **Google Cloud Storage (GCS):** Provides a scalable and secure storage solution for data during the processing pipeline.
* **BigQuery:** A powerful serverless data warehouse that enables efficient analysis and reporting on the processed e-commerce data.
* **dbt (Data Build Tool):** Transforms and models data within BigQuery, enabling advanced analysis and reporting.

This README.md serves as a comprehensive guide, outlining the project's structure, setup instructions, and key components.

## Table of Contents

1. **E-commerce Database Setup**
    * Database Schema
    * Data Loading
2. **Airflow Setup**
    * Installation
    * Configuration
    * Docker Configuration
        * Containerization
        * Docker Compose
    * DAGs (Directed Acyclic Graphs)
        * Workflow Definition
        * Tasks
3. **Data Migration**
    * ETL Process
    * Data Movement
4. **dbt Setup**
    * Installation
    * Configuration
    * Model Creation
    * Analyses
    * Results
5. **Additional Notes**
    * Error Handling
    * Scalability
    * Security
6. **Getting Started**
7. **Contributing**
8. **License**

## 1. E-commerce Database Setup

### 1.1 Database Schema

The database schema is meticulously designed to accommodate a wide range of e-commerce data, including:

* **Customer Information:** The `olist_customers` table stores details like customer ID, unique ID, zip code, city, and state.
* **Orders:** The `olist_orders` table captures order information, including order ID, customer ID, order status, timestamps, delivery details, and more.
* **Order Items:** The `olist_order_items` table records details about individual items within each order, such as product ID, seller ID, shipping dates, price, and freight value.
* **Payments:** The `olist_order_payments` table stores payment details associated with each order, including payment type, installments, and value.
* **Reviews:** The `olist_order_reviews` table holds customer reviews for orders, including review ID, score, comments, and timestamps.
* **Products:** The `olist_products` table contains product details, such as product ID, category, name, description, photos quantity, weight, and dimensions.
* **Sellers:** The `olist_sellers` table stores seller information, including seller ID, zip code, city, and state.
* **Product Category Translations:** The `product_category_name_translation` table provides translations for product category names.
* **Geolocation Data:** The `olist_geolocation` table contains geolocation data for zip codes, including latitude, longitude, city, and state.

### 1.2 Data Loading

The schema creation process involves defining tables with appropriate columns and constraints, followed by loading data from CSV files into these tables. This ensures that the data is structured correctly and ready for processing.

**Steps:**

1. **Create Tables:** Define the tables with their respective columns and data types using SQL commands.
2. **Load Data:** Use SQL commands to load data from CSV files into the created tables.
3. **Validate Data:** Verify the data integrity and completeness after loading.

## 2. Airflow Setup

### 2.1 Installation

Apache Airflow is installed and configured to run within a Docker container, providing a consistent and isolated environment for managing the data pipeline.

**Steps:**

1. **Install Docker:** Download and install Docker on your system.
2. **Install Docker Compose:** Install Docker Compose using `pip install docker-compose`.
3. **Build Docker Image:** Create a Dockerfile to define the Airflow environment and build the image using `docker build -t airflow-image .`.
4. **Run Airflow Container:** Use `docker run -d -p 8080:8080 airflow-image` to start the Airflow container.

### 2.2 Configuration

Airflow is configured to connect to PostgreSQL for metadata storage and to Google Cloud for data transfer. Environment variables are used to manage sensitive information and configuration settings securely.

**Steps:**

1. **Create Airflow Configuration:** Create an `airflow.cfg` file to configure Airflow settings, including database connection details, Google Cloud credentials, and other parameters.
2. **Set Environment Variables:** Define environment variables for sensitive information, such as database passwords and API keys, using a `.env` file or system-level environment variables.
3. **Configure Connections:** Define connections within Airflow to PostgreSQL and Google Cloud using the `airflow connections` command.

### 2.3 Docker Configuration

#### 2.3.1 Containerization

Docker is used to create containers for both PostgreSQL and Airflow, ensuring consistent environments across different systems.

**Steps:**

1. **Create PostgreSQL Dockerfile:** Define a Dockerfile for PostgreSQL, specifying the image, version, and configuration.
2. **Create Airflow Dockerfile:** Define a Dockerfile for Airflow, specifying the image, version, and dependencies.
3. **Build Docker Images:** Build the Docker images for PostgreSQL and Airflow using `docker build -t postgres-image .` and `docker build -t airflow-image .`, respectively.

#### 2.3.2 Docker Compose

A `docker-compose.yml` file is used to define and manage the multi-container application, specifying the services, volumes, and networks required for the project.

**Steps:**

1. **Create docker-compose.yml:** Define the services, volumes, and networks for PostgreSQL and Airflow in the `docker-compose.yml` file.
2. **Start Containers:** Use `docker-compose up -d` to start the containers in detached mode.

### 2.4 DAGs (Directed Acyclic Graphs)

#### 2.4.1 Workflow Definition

DAGs are used to define the workflow for data processing. Each DAG specifies tasks to be performed and their order of execution.

**Steps:**

1. **Create DAG File:** Create a Python file for each DAG, defining the tasks and their dependencies.
2. **Define Tasks:** Use Airflow operators to define tasks, such as `BashOperator`, `PythonOperator`, `GoogleCloudStorageToBigQueryOperator`, etc.
3. **Set Dependencies:** Use the `>>` operator to define dependencies between tasks.

#### 2.4.2 Tasks

The DAGs include tasks for:

* **Data Extraction:** Extracting data from PostgreSQL and saving it to Google Cloud Storage.
* **Data Loading:** Loading data from Google Cloud Storage into BigQuery.

The DAGs are configured to handle errors, retries, and logging, ensuring robustness and reliability of the ETL process.

## 3. Data Migration

### 3.1 ETL Process

The ETL process involves moving data from PostgreSQL to BigQuery. This process includes:

* **Extraction:** Extracting data from PostgreSQL tables and saving it in a suitable format (e.g., Parquet) to Google Cloud Storage.
* **Transformation:** Data may be transformed during the extraction process to ensure it is in the correct format for loading into BigQuery.
* **Loading:** Loading the transformed data from Google Cloud Storage into BigQuery tables for analysis and reporting.

### 3.2 Data Movement

The data migration process is managed by Airflow DAGs, ensuring that the data is moved and transformed efficiently and accurately.

**Steps:**

1. **Define DAG:** Create a DAG to orchestrate the ETL process.
2. **Extract Data:** Use an Airflow operator to extract data from PostgreSQL and save it to GCS.
3. **Transform Data:** Use an Airflow operator to transform the data if necessary.
4. **Load Data:** Use an Airflow operator to load the data from GCS into BigQuery.

## 4. dbt Setup

### 4.1 Installation

**Steps:**

1. **Install dbt:** Install dbt using `pip install dbt-bigquery`.
2. **Initialize dbt Project:** Navigate to your project directory and run `dbt init capstone` to initialize the dbt project.

### 4.2 Configuration

* **`dbt_project.yml`:** Configures the dbt project, specifying model paths, analysis paths, and other settings.
* **`profiles.yml`:** Sets up connection details for BigQuery, including the project ID, dataset, and credentials.

### 4.3 Model Creation

dbt models are organized into three categories:

* **Staging Models:** Serve as an initial layer of data processing, where raw data is cleaned and transformed.
* **Intermediate Models:** Aggregate and further transform data, preparing it for final analysis.
* **Final Models:** Contain the final, ready-for-analysis data, often materialized as tables.

### 4.4 Analyses

Analyses are SQL queries and scripts that answer specific business questions. For example, identifying the number of orders per state:


### 4.5 Results
The results of the analyses are captured in snapshots, providing a historical view of the data at different points in time. The results answer key business questions and are stored in the snapshots directory as json files. We can deduce from the results gotten that top 3 product categories with the highest sales are 'beleza_saude','cama_mesa_banho' and 'informatica_acessorios'. We can also observe that that average delivery time for orders was up to 12 days while the top 3 states with the highest orders were São Paulo, Rio de Janeiro and Minas Gerais.

### 5. Additional Notes
## 5.1 Error Handling
Detailed error logging and handling are implemented to capture and address any issues that arise during the ETL process.

**Steps:**

**Implement Error Logging:** Use Airflow's logging capabilities to capture errors and warnings during task execution.
**Handle Errors:** Implement error handling mechanisms within DAGs to retry failed tasks or trigger alerts.
## 5.2 Scalability
The setup is designed to be scalable, allowing for additional tables or data sources to be incorporated into the pipeline as needed.

***Steps:***

**Use Scalable Components:** Leverage scalable components like BigQuery and GCS for data storage and processing.
**Design for Scalability:** Design the pipeline architecture to handle increasing data volumes and processing demands.
## 5.3 Security
Sensitive information, such as database credentials and API keys, is managed using environment variables and secure storage solutions.

***Steps:***

**Use Environment Variables:** Store sensitive information in environment variables, which are not committed to version control.
**Use Secure Storage:** Utilize secure storage solutions like Google Cloud Secret Manager to store and manage sensitive credentials.
### 6. Getting Started
**Clone the repository:** `git clone [repository URL]`
**Install dependencies:** `pip install -r requirements.txt`
**Build Docker images:** `docker-compose build`
**Start the containers:** `docker-compose up -d`
**Run Airflow:** Access the Airflow web interface at http://localhost:8080
**Run dbt models:** Navigate to the dbt project directory and run dbt run to build the models.
**Execute DAGs:** Trigger the DAGs within the Airflow web interface to initiate the data processing and migration.
**Run dbt analyses:** Execute dbt analyses using `dbt run`-operation <operation_name> or manually run specific analysis scripts.
## 7. Contributing
Contributions are welcome! Please open an issue or submit a pull request.

## 8. License
This project is licensed under the MIT License.
