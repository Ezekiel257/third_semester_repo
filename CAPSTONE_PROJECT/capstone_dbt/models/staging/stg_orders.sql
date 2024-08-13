with order_items as (
    select
        oi.order_id,
        oi.product_id,
        oi.price,
        oi.freight_value,
        p.product_category_name
    from {{ source('capstoneproject', 'olist_order_items') }} oi
    join {{ source('capstoneproject', 'olist_products') }} p
    on oi.product_id = p.product_id
),

orders as (
    select
        o.order_id,
        o.customer_id,
        o.order_status,
        o.order_purchase_timestamp,
        o.order_approved_at,
        o.order_delivered_carrier_date,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,
        oi.product_id,
        oi.price,
        oi.freight_value,
        oi.product_category_name  -- Use the column directly from the order_items CTE
    from {{ source('capstoneproject', 'olist_orders') }} o
    join order_items oi
    on o.order_id = oi.order_id
)

select * from orders
