-- Create schema if it does not exist
CREATE SCHEMA IF NOT EXISTS FIT_PRO;

-- Create and populate PRODUCTS table
CREATE TABLE IF NOT EXISTS FIT_PRO.PRODUCTS
(
    id SERIAL PRIMARY KEY, -- Unique identifier for each product
    name VARCHAR(255) NOT NULL, -- Name of the product, limit length to 255 characters
    price NUMERIC(10, 2) NOT NULL -- Price of the product with precision of 10 digits and 2 decimal places
);

-- Import data into PRODUCTS table from a CSV file
COPY FIT_PRO.PRODUCTS (id, name, price)
FROM 'C:\Users\HP\Downloads\products.csv' DELIMITER ',' CSV HEADER; -- Importing data from CSV with comma delimiter and header

-- Create and populate CUSTOMERS table
CREATE TABLE IF NOT EXISTS FIT_PRO.CUSTOMERS
(
    customer_id UUID PRIMARY KEY, -- Unique identifier for each customer
    device_id UUID NOT NULL, -- Unique identifier for the device used by the customer
    location VARCHAR(300), -- Location of the customer, allowing up to 300 characters
    currency CHAR(3) -- Currency code typically represented with 3 characters
);

-- Import data into CUSTOMERS table from a CSV file
COPY FIT_PRO.CUSTOMERS (customer_id, device_id, location, currency)
FROM 'C:\Users\HP\Downloads\customer.csv' DELIMITER ',' CSV HEADER; -- Importing customer data from CSV file

-- Create ORDERS table
CREATE TABLE IF NOT EXISTS FIT_PRO.ORDERS
(
    order_id UUID PRIMARY KEY, -- Unique identifier for each order
    customer_id UUID REFERENCES FIT_PRO.CUSTOMERS(customer_id), -- Reference to the customer who placed the order
    status VARCHAR(30) NOT NULL, -- Status of the order, limited to 30 characters
    checked_out_at TIMESTAMP WITH TIME ZONE -- Timestamp indicating when the order was checked out, with timezone information
);

-- Import data into ORDERS table from a CSV file
COPY FIT_PRO.ORDERS (order_id, customer_id, status, checked_out_at)
FROM 'C:\Users\HP\Downloads\orders.csv' DELIMITER ',' CSV HEADER; -- Importing order data from CSV file

-- Create EVENTS table
CREATE TABLE IF NOT EXISTS FIT_PRO.EVENTS
(
    event_id SERIAL PRIMARY KEY, -- Unique identifier for each event
    customer_id UUID REFERENCES FIT_PRO.CUSTOMERS(customer_id), -- Reference to the customer associated with the event
    event_data JSONB NOT NULL, -- JSONB data type for storing JSON objects representing event data
    event_timestamp DATE NOT NULL -- Date of the event, without time information
);

-- Import data into EVENTS table from a CSV file
COPY FIT_PRO.EVENTS (event_id, customer_id, event_data, event_timestamp)
FROM 'C:\Users\HP\Downloads\events.csv' DELIMITER ',' CSV HEADER; -- Importing event data from CSV file

-- Create LINE_ITEMS table
CREATE TABLE IF NOT EXISTS FIT_PRO.LINE_ITEMS
(
    line_item_id SERIAL PRIMARY KEY, -- Unique identifier for each line item
    order_id UUID REFERENCES FIT_PRO.ORDERS(order_id), -- Reference to the order to which the line item belongs
    quantity INTEGER NOT NULL, -- Quantity of the product in the line item, stored as an integer
    item_id INTEGER -- Assuming item_id is an integer; add REFERENCES if needed
);

-- Import data into LINE_ITEMS table from a CSV file
COPY ALT_SCHOOL.LINE_ITEMS (line_item_id, order_id, quantity, item_id)
FROM 'C:\Users\HP\Downloads\line_items.csv' DELIMITER ',' CSV HEADER; -- Importing line item data from CSV file