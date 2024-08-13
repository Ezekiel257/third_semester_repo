-- models/staging/stg_products.sql

--This model will pull in raw product data, possibly joining with
--the product category translations to include English names.

with raw_products as (
    select
        product_id,
        product_category_name,
        product_name_lenght,
        product_description_lenght,
        product_photos_qty,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm
    from {{ source('capstoneproject', 'olist_products') }}
),

product_categories as (
    select
        p.product_id,
        p.product_category_name,
        p.product_name_lenght,
        p.product_description_lenght,
        p.product_photos_qty,
        p.product_weight_g,
        p.product_length_cm,
        p.product_height_cm,
        p.product_width_cm,
        c.product_category_name_english
    from raw_products p
    left join {{ source('capstoneproject', 'product_category_name_translation') }} c
    on p.product_category_name = c.product_category_name
)

select * from product_categories