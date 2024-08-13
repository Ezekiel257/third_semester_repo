--models/final/fct_orders_by_state.sql

--Aggregates orders and sales data by state, 
--including total orders, total sales, and average order value.

WITH orders_by_state AS (
    SELECT
        c.customer_state AS state,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.price * oi.order_item_id) AS total_sales
    FROM
        {{ source('capstoneproject', 'olist_orders') }} o
    JOIN
        {{ source('capstoneproject', 'olist_customers') }} c ON o.customer_id = c.customer_id
    JOIN
        {{ source('capstoneproject', 'olist_order_items') }} oi ON o.order_id = oi.order_id
    WHERE
        o.order_status = 'delivered'
    GROUP BY
        c.customer_state
)

SELECT
    state,
    total_orders,
    total_sales,
    total_sales / NULLIF(total_orders, 0) AS avg_order_value
FROM
    orders_by_state