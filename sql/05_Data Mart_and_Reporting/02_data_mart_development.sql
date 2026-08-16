-- ============================================================
-- STEP 28 — DATA MART DEVELOPMENT
-- Tujuan: Membangun tabel siap pakai untuk dashboard/reporting,
--         fokus ke metrik yang sudah tervalidasi (Step 14)
-- ============================================================

-- ----- MART 1: Revenue Monthly (tervalidasi, aman dipakai) -----
DROP TABLE IF EXISTS mart_revenue_monthly;
CREATE TABLE mart_revenue_monthly AS
SELECT
    DATE_TRUNC('month', order_date) AS bulan,
    COUNT(DISTINCT order_id) AS total_order,
    COUNT(DISTINCT customer_id) AS active_customer,
    ROUND(SUM(sales), 2) AS revenue,
    ROUND(SUM(benefit_per_order), 2) AS profit,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM orders_clean
GROUP BY 1
ORDER BY 1;

-- ----- MART 2: Region Performance (tervalidasi, aman dipakai) -----
DROP TABLE IF EXISTS mart_region_performance;
CREATE TABLE mart_region_performance AS
SELECT
    market,
    order_region,
    COUNT(DISTINCT order_id) AS total_order,
    COUNT(DISTINCT customer_id) AS jumlah_customer,
    ROUND(SUM(sales), 2) AS revenue,
    ROUND(SUM(sales) * 100.0 / SUM(SUM(sales)) OVER (), 2) AS pct_kontribusi_revenue,
    ROUND(SUM(benefit_per_order), 2) AS profit
FROM orders_clean
GROUP BY 1, 2
ORDER BY revenue DESC;

-- ----- MART 3: Product & Category Performance (tervalidasi) -----
DROP TABLE IF EXISTS mart_product_performance;
CREATE TABLE mart_product_performance AS
SELECT
    category_name,
    product_name,
    COUNT(DISTINCT order_id) AS total_order,
    SUM(order_qty) AS total_qty,
    ROUND(SUM(sales), 2) AS revenue,
    ROUND(SUM(benefit_per_order), 2) AS profit,
    SUM(CASE WHEN EXTRACT(year FROM order_date) = 2016 THEN sales ELSE 0 END) AS revenue_2016,
    SUM(CASE WHEN EXTRACT(year FROM order_date) = 2017 THEN sales ELSE 0 END) AS revenue_2017,
    ROUND(
        (SUM(CASE WHEN EXTRACT(year FROM order_date) = 2017 THEN sales ELSE 0 END)
        - SUM(CASE WHEN EXTRACT(year FROM order_date) = 2016 THEN sales ELSE 0 END))
        * 100.0 / NULLIF(SUM(CASE WHEN EXTRACT(year FROM order_date) = 2016 THEN sales ELSE 0 END), 0)
    , 2) AS pct_growth_2016_2017
FROM orders_clean
GROUP BY 1, 2;

-- ----- MART 4: Category Summary (rollup dari mart 3) -----
DROP TABLE IF EXISTS mart_category_summary;
CREATE TABLE mart_category_summary AS
SELECT
    category_name,
    COUNT(DISTINCT product_name) AS jumlah_produk,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(revenue),0), 2) AS margin_pct
FROM mart_product_performance
GROUP BY 1
ORDER BY revenue DESC;

-- ----- MART 5: Customer Summary (VALID untuk volume, TIDAK VALID untuk concentration/churn claim) -----
DROP TABLE IF EXISTS mart_customer_summary;
CREATE TABLE mart_customer_summary AS
SELECT
    customer_id,
    customer_segment,
    customer_country,
    COUNT(DISTINCT order_id) AS total_order,
    ROUND(SUM(sales), 2) AS total_revenue,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM orders_clean
GROUP BY 1, 2, 3;

-- ----- TABEL DOKUMENTASI: Data Quality Flags -----
DROP TABLE IF EXISTS data_quality_flags;
CREATE TABLE data_quality_flags (
    kolom_atau_metrik VARCHAR,
    status VARCHAR,
    catatan VARCHAR
);
INSERT INTO data_quality_flags VALUES
('delivery_status, late_delivery_risk, shipping_days_actual', 'TIDAK VALID', 'Deterministik dari shipping_mode (First Class selalu 2 hari, 0 variasi) — jangan pakai untuk klaim OTIF/keterlambatan riil'),
('discount_rate, discount_amount', 'TIDAK VALID', 'Tidak ada elastisitas terhadap qty (flat di semua level diskon) — jangan pakai untuk klaim efektivitas promosi'),
('Order rugi ~18-19%', 'TIDAK VALID', 'Rate rugi merata di semua dimensi (kategori, status, segment, shipping mode) — pola random, bukan masalah bisnis spesifik'),
('New vs Repeat Customer, Nov 2017 - Jan 2018', 'TIDAK VALID', 'customer_id di periode ini tidak overlap dengan histori sebelumnya (100% "customer baru") — kemungkinan cacat struktural di ekor dataset'),
('Revenue Concentration by Customer', 'TIDAK VALID', 'Top 10 customer hanya 0.28% dari total revenue — customer base terlalu tersebar untuk merepresentasikan konsep Distributor Concentration Risk'),
('order_date 2018', 'CAVEAT', 'Hanya tersedia data Januari 2018 — exclude dari perbandingan YoY, jangan dibaca sebagai revenue collapse'),
('sales, revenue, profit_per_order', 'VALID', 'Konsisten di semua pengecekan, aman dipakai untuk KPI Revenue & Financial'),
('order_region, market', 'VALID', 'Distribusi wajar, tidak ada tanda artifisial'),
('Product Growth 2016 vs 2017', 'VALID', 'Konsisten dengan tren revenue total (-38%), signal bisnis nyata bukan noise');

-- ----- CEK HASIL -----
SELECT 'mart_revenue_monthly' AS mart, COUNT(*) AS rows FROM mart_revenue_monthly
UNION ALL SELECT 'mart_region_performance', COUNT(*) FROM mart_region_performance
UNION ALL SELECT 'mart_product_performance', COUNT(*) FROM mart_product_performance
UNION ALL SELECT 'mart_category_summary', COUNT(*) FROM mart_category_summary
UNION ALL SELECT 'mart_customer_summary', COUNT(*) FROM mart_customer_summary
UNION ALL SELECT 'data_quality_flags', COUNT(*) FROM data_quality_flags;

-- Temuan:
-- Semua 6 tabel berhasil dibuat tanpa error, row count konsisten dengan
-- angka-angka yang sudah divalidasi di step-step sebelumnya:
-- mart_revenue_monthly (37), mart_region_performance (22),
-- mart_product_performance (118), mart_category_summary (50),
-- mart_customer_summary (18.296), data_quality_flags (9)

-- Kesimpulan:
-- Database Dataco.duckdb sekarang punya struktur 3 lapis:
-- 1. Raw layer   : orders (mentah, varchar semua)
-- 2. Clean layer : orders_clean (tipe data benar, tervalidasi)
-- 3. Mart layer  : 5 tabel agregat siap pakai + 1 tabel dokumentasi kualitas data
-- Tabel data_quality_flags berfungsi sebagai safety net agar siapa pun yang
-- memakai dashboard ini nanti tetap tahu batasan & validitas tiap metrik.
