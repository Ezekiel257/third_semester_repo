--models/final/fct_sales_by_category.sql

--Aggregates sales data by product category, 
--including total sales, number of orders, and average order value.

WITH sales_by_category AS (
    SELECT
        p.product_category_name AS category,
        SUM(oi.price * oi.order_item_id) AS total_sales,
        COUNT(DISTINCT o.order_id) AS num_orders
    FROM
        {{ source('capstoneproject', 'olist_order_items') }} oi
    JOIN
        {{ source('capstoneproject', 'olist_orders') }} o ON oi.order_id = o.order_id
    JOIN
        {{ source('capstoneproject', 'olist_products') }} p ON oi.product_id = p.product_id
    WHERE
        o.order_status = 'delivered'
    GROUP BY
        p.product_category_name
)

SELECT
    category AS product_category_name,
    total_sales,
    num_orders,
    total_sales / NULLIF(num_orders, 0) AS avg_order_value
FROM
    sales_by_category