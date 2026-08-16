-- ============================================================
-- DATA PROFILING
-- Tujuan: Load data mentah & kenalan sama isi data (null, unique, duplikat, tanggal)
-- ============================================================

-- ----- LOAD DATA -----

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS data_dictionary;

-- Load data utama (semua kolom sebagai teks dulu, paling aman terhadap encoding aneh)
CREATE TABLE orders AS
SELECT * FROM read_csv(
    'C:\Users\ahmad farid\Downloads\FMCG\archive\DataCoSupplyChainDataset.csv',
    all_varchar = true,
    ignore_errors = true,
    header = true
);

-- Load kamus data
CREATE TABLE data_dictionary AS
SELECT * FROM read_csv(
    'C:\Users\ahmad farid\Downloads\FMCG\archive\DescriptionDataCoSupplyChain.csv',
    all_varchar = true,
    ignore_errors = true,
    header = true
);

-- ----- CEK HASIL LOAD -----

SELECT 'orders' AS table_name, COUNT(*) AS total_rows FROM orders
UNION ALL
SELECT 'data_dictionary', COUNT(*) FROM data_dictionary;

DESCRIBE orders;

-- ----- ANOMALI: CEK NULL DI KOLOM KUNCI -----

SELECT
    SUM(CASE WHEN "Order Id" IS NULL OR "Order Id" = '' THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN "Customer Id" IS NULL OR "Customer Id" = '' THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN Sales IS NULL OR Sales = '' THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN "Order Region" IS NULL OR "Order Region" = '' THEN 1 ELSE 0 END) AS null_region,
    SUM(CASE WHEN "Product Name" IS NULL OR "Product Name" = '' THEN 1 ELSE 0 END) AS null_product,
    SUM(CASE WHEN "order date (DateOrders)" IS NULL OR "order date (DateOrders)" = '' THEN 1 ELSE 0 END) AS null_order_date
FROM orders;

-- ----- CEK JUMLAH NILAI UNIK (KATEGORI) -----

SELECT
    COUNT(DISTINCT Market) AS n_market,
    COUNT(DISTINCT "Order Region") AS n_region,
    COUNT(DISTINCT "Order Country") AS n_country,
    COUNT(DISTINCT "Customer Segment") AS n_customer_segment,
    COUNT(DISTINCT "Order Status") AS n_order_status,
    COUNT(DISTINCT "Delivery Status") AS n_delivery_status,
    COUNT(DISTINCT "Shipping Mode") AS n_shipping_mode,
    COUNT(DISTINCT "Category Name") AS n_category,
    COUNT(DISTINCT "Customer Id") AS n_customer,
    COUNT(DISTINCT "Order Id") AS n_order
FROM orders;

-- ----- ANOMALI: CEK TANGGAL BISA DI-PARSE OTOMATIS (TRY_CAST) -----
-- (baseline check: hasilnya semua gagal -> format tanggal tidak standar, ditelusuri lebih lanjut)

SELECT
    MIN(TRY_CAST("order date (DateOrders)" AS TIMESTAMP)) AS earliest_order,
    MAX(TRY_CAST("order date (DateOrders)" AS TIMESTAMP)) AS latest_order,
    SUM(CASE WHEN TRY_CAST("order date (DateOrders)" AS TIMESTAMP) IS NULL THEN 1 ELSE 0 END) AS failed_to_parse
FROM orders;

-- Cek bentuk mentah tanggal untuk menentukan format yang tepat
SELECT DISTINCT "order date (DateOrders)" FROM orders LIMIT 50;
SELECT DISTINCT "shipping date (DateOrders)" FROM orders LIMIT 5;

-- Validasi ulang dengan format yang benar: %-m/%-d/%Y %-H:%M
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN TRY_STRPTIME("order date (DateOrders)", '%-m/%-d/%Y %-H:%M') IS NULL THEN 1 ELSE 0 END) AS masih_gagal_parse,
    MIN(TRY_STRPTIME("order date (DateOrders)", '%-m/%-d/%Y %-H:%M')) AS earliest_order,
    MAX(TRY_STRPTIME("order date (DateOrders)", '%-m/%-d/%Y %-H:%M')) AS latest_order
FROM orders;

-- ----- ANOMALI: CEK DUPLIKAT (Order Id + Order Item Id harusnya unik per item) -----

SELECT "Order Id", "Order Item Id", COUNT(*) AS jumlah
FROM orders
GROUP BY 1, 2
HAVING COUNT(*) > 1
LIMIT 10;

-- Referensi isi kategori kunci
SELECT DISTINCT Market FROM orders ORDER BY 1;

-- Temuan:
-- - 114.187 baris, 53 kolom berhasil dimuat
-- - 0 null di kolom kunci (Order Id, Customer Id, Sales, Region, Product, Order Date)
-- - Kategori bersih: 5 Market, 22 Region, 115 Country, 3 Customer Segment, dst
-- - TRY_CAST standar gagal 100% -> format tanggal ternyata "M/D/YYYY H:MM" (tanpa leading zero)
-- - Setelah pakai TRY_STRPTIME dengan format yang benar: 0 gagal parse,
--   rentang tanggal 2015-01-01 s/d 2018-01-31 (masuk akal, ~3 tahun data)
-- - 0 duplikat Order Id + Order Item Id
