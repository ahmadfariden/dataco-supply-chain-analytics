-- ============================================================
-- DATA CLEANING
-- Tujuan: Bikin tabel bersih (orders_clean) dengan tipe data yang benar
--         dan nama kolom SQL-friendly (snake_case, tanpa spasi)
-- ============================================================

DROP TABLE IF EXISTS orders_clean;

CREATE TABLE orders_clean AS
SELECT
    CAST("Order Id" AS INTEGER)                            AS order_id,
    CAST("Order Item Id" AS INTEGER)                        AS order_item_id,
    CAST("Order Customer Id" AS INTEGER)                     AS customer_id,
    "Customer Segment"                                       AS customer_segment,
    "Customer City"                                          AS customer_city,
    "Customer State"                                         AS customer_state,
    "Customer Country"                                       AS customer_country,
    Market                                                   AS market,
    "Order Region"                                           AS order_region,
    "Order Country"                                          AS order_country,
    "Order State"                                            AS order_state,
    "Order City"                                             AS order_city,
    CAST("Product Card Id" AS INTEGER)                       AS product_id,
    "Product Name"                                           AS product_name,
    "Category Name"                                          AS category_name,
    "Department Name"                                        AS department_name,
    CAST(Sales AS DOUBLE)                                    AS sales,
    CAST("Order Item Quantity" AS INTEGER)                   AS order_qty,
    CAST("Order Item Discount" AS DOUBLE)                    AS discount_amount,
    CAST("Order Item Discount Rate" AS DOUBLE)                AS discount_rate,
    CAST("Order Item Product Price" AS DOUBLE)                AS product_price,
    CAST("Order Item Total" AS DOUBLE)                        AS order_item_total,
    CAST("Order Item Profit Ratio" AS DOUBLE)                 AS profit_ratio,
    CAST("Order Profit Per Order" AS DOUBLE)                  AS profit_per_order,
    CAST("Benefit per order" AS DOUBLE)                       AS benefit_per_order,
    "Order Status"                                           AS order_status,
    "Delivery Status"                                        AS delivery_status,
    CAST(Late_delivery_risk AS INTEGER)                      AS late_delivery_risk,
    CAST("Days for shipping (real)" AS INTEGER)               AS shipping_days_actual,
    CAST("Days for shipment (scheduled)" AS INTEGER)          AS shipping_days_scheduled,
    "Shipping Mode"                                          AS shipping_mode,
    STRPTIME("order date (DateOrders)", '%-m/%-d/%Y %-H:%M')     AS order_date,
    STRPTIME("shipping date (DateOrders)", '%-m/%-d/%Y %-H:%M') AS shipping_date
FROM orders;

-- ----- CEK HASIL CLEANING -----

SELECT COUNT(*) AS total_rows FROM orders_clean;
DESCRIBE orders_clean;

-- Temuan:
-- - 114.187 baris berhasil masuk ke orders_clean (tidak ada baris hilang saat konversi)
-- - Semua tipe data sudah benar: INTEGER, DOUBLE, VARCHAR, TIMESTAMP
-- - Nama kolom sudah snake_case, tanpa spasi, siap dipakai untuk query lanjutan
