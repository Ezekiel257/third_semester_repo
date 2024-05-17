-- Create schema if it does not exist
CREATE SCHEMA IF NOT EXISTS superstore;

-- Create CUSTOMERS table
CREATE TABLE IF NOT EXISTS superstore.customers (
    customer_id VARCHAR(50) PRIMARY KEY, -- Unique identifier for each customer
    customer_name VARCHAR(50) NOT NULL, -- Name of the customer
    segment VARCHAR(50) NOT NULL, -- Customer segment
    country_region VARCHAR(50) NOT NULL, -- Country or region of the customer
    city VARCHAR(50) NOT NULL, -- City of the customer
    state_province VARCHAR(50) NOT NULL, -- State or province of the customer
    postal_code VARCHAR(50), -- Postal code of the customer
    region VARCHAR(50) NOT NULL -- Region of the customer
);

-- Import data into CUSTOMERS table from a CSV file
COPY superstore.customers (customer_id, customer_name, segment, country_region, city, state_province, postal_code, region)
FROM 'C:\Users\HP\Desktop\altschool_project\third_semester_repo\Postgres_Docker\postgres_docker_init\data\customers.csv' DELIMITER ',' CSV HEADER; -- Importing customer data from CSV file

-- Create PRODUCTS table
CREATE TABLE IF NOT EXISTS superstore.products (
    product_id VARCHAR(50) PRIMARY KEY, -- Unique identifier for each product
    category VARCHAR(50) NOT NULL, -- Product category
    sub_category VARCHAR(50) NOT NULL, -- Product sub-category
    product_name VARCHAR(128) NOT NULL -- Name of the product
);

-- Import data into PRODUCTS table from a CSV file
COPY superstore.products (product_id, category, sub_category, product_name)
FROM 'C:\Users\HP\Desktop\altschool_project\third_semester_repo\Postgres_Docker\postgres_docker_init\data\products.csv' DELIMITER ',' CSV HEADER; -- Importing product data from CSV file

-- Create ORDERS table
CREATE TABLE IF NOT EXISTS superstore.orders (
    order_id VARCHAR(50) PRIMARY KEY, -- Unique identifier for each order
    order_date VARCHAR(50) NOT NULL, -- Order date
    ship_date VARCHAR(50) NOT NULL, -- Shipping date
    ship_mode VARCHAR(50) NOT NULL, -- Shipping mode
    customer_id VARCHAR(50) REFERENCES superstore.customers(customer_id), -- Reference to the customer who placed the order
    product_id VARCHAR(50) REFERENCES superstore.products(product_id), -- Reference to the product in the order
    sales FLOAT NOT NULL, -- Sales amount
    quantity INT NOT NULL, -- Quantity of the product in the order
    discount FLOAT NOT NULL, -- Discount applied to the order
    profit FLOAT NOT NULL -- Profit from the order
);

-- Import data into ORDERS table from a CSV file
COPY superstore.orders (order_id, order_date, ship_date, ship_mode, customer_id, product_id, sales, quantity, discount, profit)
FROM 'C:\Users\HP\Desktop\altschool_project\third_semester_repo\Postgres_Docker\postgres_docker_init\data\orders.csv' DELIMITER ',' CSV HEADER; -- Importing order data from CSV file

-- Create ARCHIVED_ORDERS table
CREATE TABLE IF NOT EXISTS superstore.archived_orders (
    order_id VARCHAR(50) PRIMARY KEY, -- Unique identifier for each archived order
    order_date VARCHAR(50) NOT NULL, -- Order date
    ship_date VARCHAR(50) NOT NULL, -- Shipping date
    ship_mode VARCHAR(50) NOT NULL, -- Shipping mode
    customer_id VARCHAR(50) REFERENCES superstore.customers(customer_id), -- Reference to the customer who placed the order
    product_id VARCHAR(50) REFERENCES superstore.products(product_id), -- Reference to the product in the order
    sales FLOAT NOT NULL, -- Sales amount
    quantity INT NOT NULL, -- Quantity of the product in the order
    discount FLOAT NOT NULL, -- Discount applied to the order
    profit FLOAT NOT NULL -- Profit from the order
);

-- Import data into ARCHIVED_ORDERS table from a CSV file
COPY superstore.archived_orders (order_id, order_date, ship_date, ship_mode, customer_id, product_id, sales, quantity, discount, profit)
FROM 'C:\Users\HP\Desktop\altschool_project\third_semester_repo\Postgres_Docker\postgres_docker_init\data\archived_orders.csv' DELIMITER ',' CSV HEADER; -- Importing archived order data from CSV file
