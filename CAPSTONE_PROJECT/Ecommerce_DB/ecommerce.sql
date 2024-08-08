-- Create the 'olist_customers' table
CREATE TABLE olist_customers (
    customer_id VARCHAR PRIMARY KEY,  -- Customer ID, unique identifier
    customer_unique_id VARCHAR,      -- Unique identifier for the customer
    customer_zip_code_prefix INTEGER, -- Zip code prefix of the customer's address
    customer_city VARCHAR,          -- City of the customer's address
    customer_state VARCHAR           -- State of the customer's address
);

-- Create the 'olist_orders' table
CREATE TABLE olist_orders (
    order_id VARCHAR PRIMARY KEY,  -- Order ID, unique identifier
    customer_id VARCHAR,          -- Customer ID associated with the order
    order_status VARCHAR,         -- Status of the order (e.g., 'shipped', 'delivered')
    order_purchase_timestamp TIMESTAMP, -- Timestamp when the order was placed
    order_approved_at TIMESTAMP,  -- Timestamp when the order was approved
    order_delivered_carrier_date TIMESTAMP, -- Timestamp when the order was delivered to the carrier
    order_delivered_customer_date TIMESTAMP, -- Timestamp when the order was delivered to the customer
    order_estimated_delivery_date TIMESTAMP, -- Estimated delivery date for the order
    FOREIGN KEY (customer_id) REFERENCES olist_customers (customer_id) -- Foreign key constraint linking orders to customers
);

-- Create the 'olist_order_items' table
CREATE TABLE olist_order_items (
    order_id VARCHAR,            -- Order ID associated with the item
    order_item_id INTEGER,       -- Item ID within the order
    product_id VARCHAR,          -- Product ID of the item
    seller_id VARCHAR,           -- Seller ID of the item
    shipping_limit_date TIMESTAMP, -- Shipping limit date for the item
    price NUMERIC,              -- Price of the item
    freight_value NUMERIC,       -- Freight value for the item
    PRIMARY KEY (order_id, order_item_id), -- Composite primary key for unique identification
    FOREIGN KEY (order_id) REFERENCES olist_orders (order_id), -- Foreign key constraint linking order items to orders
    FOREIGN KEY (product_id) REFERENCES olist_products (product_id), -- Foreign key constraint linking order items to products
    FOREIGN KEY (seller_id) REFERENCES olist_sellers (seller_id) -- Foreign key constraint linking order items to sellers
);

-- Create the 'olist_order_payments' table
CREATE TABLE olist_order_payments (
    order_id VARCHAR,            -- Order ID associated with the payment
    payment_sequential INTEGER,   -- Payment sequence within the order
    payment_type VARCHAR,         -- Type of payment (e.g., 'credit card', 'boleto')
    payment_installments INTEGER, -- Number of installments for the payment
    payment_value NUMERIC,        -- Value of the payment
    PRIMARY KEY (order_id, payment_sequential), -- Composite primary key for unique identification
    FOREIGN KEY (order_id) REFERENCES olist_orders (order_id) -- Foreign key constraint linking order payments to orders
);

-- Create the 'olist_order_reviews' table
CREATE TABLE olist_order_reviews (
    review_id VARCHAR PRIMARY KEY,  -- Review ID, unique identifier
    order_id VARCHAR,            -- Order ID associated with the review
    review_score INTEGER,         -- Review score (e.g., 1-5 stars)
    review_comment_title VARCHAR, -- Title of the review comment
    review_comment_message TEXT,  -- Content of the review comment
    review_creation_date TIMESTAMP, -- Timestamp when the review was created
    review_answer_timestamp TIMESTAMP, -- Timestamp when the review was answered
    FOREIGN KEY (order_id) REFERENCES olist_orders (order_id) -- Foreign key constraint linking order reviews to orders
);

-- Create the 'olist_products' table
CREATE TABLE olist_products (
    product_id VARCHAR PRIMARY KEY,  -- Product ID, unique identifier
    product_category_name VARCHAR, -- Category name of the product
    product_name_lenght INTEGER,   -- Length of the product name
    product_description_lenght INTEGER, -- Length of the product description
    product_photos_qty INTEGER,    -- Number of photos for the product
    product_weight_g INTEGER,      -- Weight of the product in grams
    product_length_cm INTEGER,     -- Length of the product in centimeters
    product_height_cm INTEGER,    -- Height of the product in centimeters
    product_width_cm INTEGER      -- Width of the product in centimeters
);

-- Create the 'olist_sellers' table
CREATE TABLE olist_sellers (
    seller_id VARCHAR PRIMARY KEY,  -- Seller ID, unique identifier
    seller_zip_code_prefix INTEGER, -- Zip code prefix of the seller's address
    seller_city VARCHAR,          -- City of the seller's address
    seller_state VARCHAR           -- State of the seller's address
);

-- Create the 'product_category_name_translation' table
CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR PRIMARY KEY, -- Category name in the original language
    product_category_name_english VARCHAR -- English translation of the category name
);

-- Create the 'olist_geolocation' table
CREATE TABLE olist_geolocation (
    geolocation_zip_code_prefix INTEGER PRIMARY KEY, -- Zip code prefix for geolocation data
    geolocation_lat NUMERIC,                     -- Latitude coordinate
    geolocation_lng NUMERIC,                     -- Longitude coordinate
    geolocation_city VARCHAR,                     -- City associated with the zip code prefix
    geolocation_state VARCHAR                     -- State associated with the zip code prefix
);
