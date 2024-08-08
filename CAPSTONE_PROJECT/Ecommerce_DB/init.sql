-- Drop tables if they exist (in reverse order to avoid foreign key constraints)
DROP TABLE IF EXISTS olist_geolocation;
DROP TABLE IF EXISTS product_category_name_translation;
DROP TABLE IF EXISTS olist_sellers;
DROP TABLE IF EXISTS olist_products;
DROP TABLE IF EXISTS olist_order_reviews;
DROP TABLE IF EXISTS olist_order_payments;
DROP TABLE IF EXISTS olist_order_items;
DROP TABLE IF EXISTS olist_orders;
DROP TABLE IF EXISTS olist_customers;

-- Create the 'olist_customers' table
CREATE TABLE olist_customers (
    customer_id VARCHAR PRIMARY KEY,
    customer_unique_id VARCHAR,
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR,
    customer_state VARCHAR
);

-- Load data from CSV into olist_customers table
COPY olist_customers (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
FROM 'C:\Users\HP\Desktop\altschool_project\third_semester_repo\CAPSTONE_PROJECT\Data\olist_customers_dataset.csv' DELIMITER ',' CSV HEADER;

-- Create the 'olist_orders' table
CREATE TABLE olist_orders (
    order_id VARCHAR PRIMARY KEY,
    customer_id VARCHAR,
    order_status VARCHAR,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES olist_customers (customer_id)
);

-- Load data from CSV into olist_orders table
COPY olist_orders (order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date)
FROM 'C:\Users\HP\Desktop\altschool_project\third_semester_repo\CAPSTONE_PROJECT\Data\olist_orders_dataset.csv' DELIMITER ',' CSV HEADER;

-- Create the 'olist_order_items' table
CREATE TABLE olist_order_items (
    order_id VARCHAR,
    order_item_id INTEGER,
    product_id VARCHAR,
    seller_id VARCHAR,
    shipping_limit_date TIMESTAMP,
    price NUMERIC,
    freight_value NUMERIC,
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES olist_orders (order_id),
    FOREIGN KEY (product_id) REFERENCES olist_products (product_id),
    FOREIGN KEY (seller_id) REFERENCES olist_sellers (seller_id)
);

-- Load data from CSV into olist_order_items table
COPY olist_order_items (order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value)
FROM 'C:\Users\HP\Desktop\altschool_project\third_semester_repo\CAPSTONE_PROJECT\Data\olist_order_items_dataset.csv' DELIMITER ',' CSV HEADER;

-- Create the 'olist_order_payments' table
CREATE TABLE olist_order_payments (
    order_id VARCHAR,
    payment_sequential INTEGER,
    payment_type VARCHAR,
    payment_installments INTEGER,
    payment_value NUMERIC,
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES olist_orders (order_id)
);

-- Load data from CSV into olist_order_payments table
COPY olist_order_payments (order_id, payment_sequential, payment_type, payment_installments, payment_value)
FROM 'C:\Users\HP\Desktop\altschool_project\third_semester_repo\CAPSTONE_PROJECT\Data\olist_order_payments_dataset.csv' DELIMITER ',' CSV HEADER;

-- Create the 'olist_order_reviews' table
CREATE TABLE olist_order_reviews (
    review_id VARCHAR PRIMARY KEY,
    order_id VARCHAR,
    review_score INTEGER,
    review_comment_title VARCHAR,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES olist_orders (order_id)
);

-- Load data from CSV into olist_order_reviews table
COPY olist_order_reviews (review_id, order_id, review_score, review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp)
FROM 'C:\Users\HP\Desktop\altschool_project\third_semester_repo\CAPSTONE_PROJECT\Data\olist_order_reviews_dataset.csv' DELIMITER ',' CSV HEADER;

-- Create the 'olist_products' table
CREATE TABLE olist_products (
    product_id VARCHAR PRIMARY KEY,
    product_category_name VARCHAR,
    product_name_length INTEGER,
    product_description_length INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);

-- Load data from CSV into olist_products table
COPY olist_products (product_id, product_category_name, product_name_length, product_description_length, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm)
FROM 'C:\Users\HP\Desktop\altschool_project\third_semester_repo\CAPSTONE_PROJECT\Data\olist_products_dataset.csv' DELIMITER ',' CSV HEADER;

-- Create the 'olist_sellers' table
CREATE TABLE olist_sellers (
    seller_id VARCHAR PRIMARY KEY,
    seller_zip_code_prefix INTEGER,
    seller_city VARCHAR,
    seller_state VARCHAR
);

-- Load data from CSV into olist_sellers table
COPY olist_sellers (seller_id, seller_zip_code_prefix, seller_city, seller_state)
FROM 'C:\Users\HP\Desktop\altschool_project\third_semester_repo\CAPSTONE_PROJECT\Data\olist_sellers_dataset.csv' DELIMITER ',' CSV HEADER;

-- Create the 'product_category_name_translation' table
CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR PRIMARY KEY,
    product_category_name_english VARCHAR
);

-- Load data from CSV into product_category_name_translation table
COPY product_category_name_translation (product_category_name, product_category_name_english)
FROM 'C:\Users\HP\Desktop\altschool_project\third_semester_repo\CAPSTONE_PROJECT\Data\product_category_name_translation.csv' DELIMITER ',' CSV HEADER;

-- Create the 'olist_geolocation' table
CREATE TABLE olist_geolocation (
    geolocation_zip_code_prefix INTEGER PRIMARY KEY,
    geolocation_lat NUMERIC,
    geolocation_lng NUMERIC,
    geolocation_city VARCHAR,
    geolocation_state VARCHAR
);

-- Load data from CSV into olist_geolocation table
COPY olist_geolocation (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state)
FROM 'C:\Users\HP\Desktop\altschool_project\third_semester_repo\CAPSTONE_PROJECT\Data\olist_geolocation_dataset.csv' DELIMITER ',' CSV HEADER;

-- Add foreign keys to olist_order_items table
ALTER TABLE olist_order_items
ADD FOREIGN KEY (product_id) REFERENCES olist_products (product_id),
ADD FOREIGN KEY (seller_id) REFERENCES olist_sellers (seller_id);
