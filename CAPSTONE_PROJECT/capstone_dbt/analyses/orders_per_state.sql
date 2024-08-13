--- Which states have the highest number of orders?

WITH orders_per_state AS (
    SELECT
        state,
        total_orders
    FROM `capstone-project-429612.capstoneproject.fct_orders_by_state`
)

SELECT
    state,
    total_orders
FROM orders_per_state
ORDER BY total_orders DESC;