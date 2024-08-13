-- models/intermediate/int_avg_delivery_time.sql

--This model calculates the average delivery time for each order, 
--defined as the difference between the order's estimated delivery date and the actual delivery date.

with delivery_times as (
    select
        o.order_id,
        o.order_estimated_delivery_date,
        o.order_delivered_customer_date,
        date_diff(o.order_delivered_customer_date, o.order_estimated_delivery_date, day) as delivery_time_days
    from {{ source('capstoneproject', 'olist_orders') }} o
    where o.order_delivered_customer_date is not null
)

select
    avg(delivery_time_days) as avg_delivery_time_days
from delivery_times
