-- models/intermediate/int_sales_by_category.sql

-- This model will aggregate sales data by product category,
-- summing up the total sales and counting the number of items sold.

with order_items as (
    select
        oi.order_id,
        oi.product_id,
        oi.price,
        oi.freight_value,
        p.product_category_name
    from {{ ref('stg_orders') }} o
    join {{ ref('stg_products') }} p
    on o.product_id = p.product_id
    join {{ source('capstoneproject', 'olist_order_items') }} oi
    on o.order_id = oi.order_id
),

category_sales as (
    select
        p.product_category_name,
        sum(oi.price) as total_sales,
        count(oi.order_id) as num_orders
    from order_items oi
    join {{ ref('stg_products') }} p
    on oi.product_id = p.product_id
    group by p.product_category_name
)

select * from category_sales