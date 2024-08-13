--models/final/fct_avg_delivery_time.sql

--Calculates the average, maximum, and minimum delivery times for orders.


WITH delivery_times AS (
    SELECT
        o.order_id,
        EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) AS delivery_time_days
    FROM
        {{ source('capstoneproject', 'olist_orders') }} o
    WHERE
        o.order_status = 'delivered'
)

SELECT
    AVG(delivery_time_days) AS avg_delivery_time_days,
    MAX(delivery_time_days) AS max_delivery_time_days,
    MIN(delivery_time_days) AS min_delivery_time_days
FROM
    delivery_times