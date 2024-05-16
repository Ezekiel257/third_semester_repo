### Postgres Docker Initialization

## Description
This project aims to set up a basic Postgres infrastructure using Docker and Docker Compose. The goal is to demonstrate the ability to create a Postgres server, load data into it, and interact with it using Python.

## Technology Used
- Docker: Used to containerize the Postgres server for easy setup and management.
- Python: Used to write scripts for connecting to the Postgres database and executing queries.

## Process Description
1. **Folder Structure Setup**:
   - Created a folder named `postgres_docker_init`.
   - Created an `src` folder within `postgres_docker_init` to hold Python scripts.

2. **Data Preparation**:
   - Placed some CSV files into the `data` folder containing sample data.

3. **Database Setup**:
   - Wrote a SQL script to create a new schema, table, and load the CSV files into the Docker Postgres container.

4. **Docker Compose Configuration**:
   - Created a `docker-compose.yml` file to define the Postgres service with port mapping to avoid conflicts.

5. **Python Scripting**:
   - Wrote Python scripts within the `src` folder to connect to the Postgres database and execute queries. 
   - Wrote a script (`postgres_connection.py`) to count the number of records in the table.

## Other Characteristics
- **Motivation**: The project aims to provide a simple yet practical example of setting up a Postgres server with Docker for learning purposes.
- **Limitations**: The setup covers only basic Postgres infrastructure and may not be suitable for production environments.
- **Challenges**: Addressing potential conflicts with existing Postgres installations on the local machine while running the Docker container.
- **Intended Use**: This project serves as a learning tool for understanding Dockerized database setups and basic Python-Postgres interactions.


