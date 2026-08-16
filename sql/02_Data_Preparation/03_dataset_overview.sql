-- ============================================================
-- STEP 10 — DATASET OVERVIEW
-- Tujuan: Pastikan kolom-kolom yang seharusnya numeric bisa dikonversi
--         dengan aman, sebelum masuk ke Data Cleaning
-- ============================================================

-- ----- ANOMALI: CEK KOLOM NUMERIC GAGAL DI-CAST -----

SELECT
    SUM(CASE WHEN TRY_CAST(Sales AS DOUBLE) IS NULL THEN 1 ELSE 0 END) AS gagal_sales,
    SUM(CASE WHEN TRY_CAST("Order Item Quantity" AS DOUBLE) IS NULL THEN 1 ELSE 0 END) AS gagal_qty,
    SUM(CASE WHEN TRY_CAST("Order Item Discount" AS DOUBLE) IS NULL THEN 1 ELSE 0 END) AS gagal_discount,
    SUM(CASE WHEN TRY_CAST("Order Item Profit Ratio" AS DOUBLE) IS NULL THEN 1 ELSE 0 END) AS gagal_profit_ratio,
    SUM(CASE WHEN TRY_CAST("Order Profit Per Order" AS DOUBLE) IS NULL THEN 1 ELSE 0 END) AS gagal_profit_per_order,
    SUM(CASE WHEN TRY_CAST("Benefit per order" AS DOUBLE) IS NULL THEN 1 ELSE 0 END) AS gagal_benefit,
    SUM(CASE WHEN TRY_CAST(Latitude AS DOUBLE) IS NULL THEN 1 ELSE 0 END) AS gagal_lat,
    SUM(CASE WHEN TRY_CAST(Longitude AS DOUBLE) IS NULL THEN 1 ELSE 0 END) AS gagal_long,
    SUM(CASE WHEN TRY_CAST("Days for shipping (real)" AS INTEGER) IS NULL THEN 1 ELSE 0 END) AS gagal_days_real,
    SUM(CASE WHEN TRY_CAST("Days for shipment (scheduled)" AS INTEGER) IS NULL THEN 1 ELSE 0 END) AS gagal_days_scheduled
FROM orders;

-- ----- CEK KATEGORI PENTING UNTUK KPI DELIVERY / OTIF -----

SELECT DISTINCT "Order Status" FROM orders ORDER BY 1;
SELECT DISTINCT "Delivery Status" FROM orders ORDER BY 1;
SELECT DISTINCT Late_delivery_risk FROM orders ORDER BY 1;

-- Temuan:
-- - Semua kolom numeric: 0% gagal konversi (Sales, Qty, Discount, Profit Ratio,
--   Profit per Order, Benefit, Latitude, Longitude, Days shipping real & scheduled)
-- - Order Status: 9 kategori (CANCELED, CLOSED, COMPLETE, ON_HOLD, PAYMENT_REVIEW,
--   PENDING, PENDING_PAYMENT, PROCESSING, SUSPECTED_FRAUD)
-- - Delivery Status: 4 kategori (Advance shipping, Late delivery,
--   Shipping canceled, Shipping on time) -> proxy untuk OTIF
-- - Late_delivery_risk: binary 0/1, bersih
