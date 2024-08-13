--- What is the average delivery time for orders?

WITH delivery_times AS (
    SELECT
        o.order_id,
        DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_purchase_timestamp), DAY) AS delivery_time_days
    FROM `capstone-project-429612.capstoneproject.stg_orders` o
    WHERE o.order_delivered_customer_date IS NOT NULL
)

SELECT
    AVG(delivery_time_days) AS avg_delivery_time_days
FROM delivery_times;