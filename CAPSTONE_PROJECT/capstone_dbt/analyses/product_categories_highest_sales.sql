--- Which product categories have the highest sales?

WITH sales_by_category AS (
    SELECT
        p.product_category_name,
        SUM(oi.price) AS total_sales
    FROM `capstone-project-429612.capstoneproject.stg_orders` o
    JOIN `capstone-project-429612.capstoneproject.stg_orders` oi
        ON o.order_id = oi.order_id
    JOIN `capstone-project-429612.capstoneproject.olist_products` p
        ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
)

SELECT
    product_category_name,
    total_sales
FROM sales_by_category
ORDER BY total_sales DESC;