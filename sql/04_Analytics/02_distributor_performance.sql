-- ============================================================
-- DISTRIBUTOR PERFORMANCE ANALYSIS
-- Tujuan: Analisis performa "distributor" (proxy: customer_id) —
--         kontribusi, risiko churn, dan pola aktivitas
-- Catatan: dataset pakai konsep Customer, bukan Distributor B2B.
--          Top 10 customer cuma 0.28% revenue (lihat Step 13/14) —
--          interpretasikan sebagai Customer Performance, bukan literal Distributor.
-- ============================================================

-- 1. Customer Activity Overview — kapan terakhir tiap customer order? (proxy Churn)
WITH last_order AS (
    SELECT
        customer_id,
        customer_segment,
        MAX(order_date) AS last_order_date,
        COUNT(DISTINCT order_id) AS total_order,
        ROUND(SUM(sales), 2) AS total_revenue
    FROM orders_clean
    GROUP BY 1, 2
)
SELECT
    customer_id,
    customer_segment,
    last_order_date,
    total_order,
    total_revenue,
    DATE_DIFF('day', last_order_date, (SELECT MAX(order_date) FROM orders_clean)) AS hari_sejak_order_terakhir
FROM last_order
ORDER BY hari_sejak_order_terakhir DESC
LIMIT 15;

-- 2. Churn Proxy — segmentasi customer berdasarkan recency
WITH last_order AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date
    FROM orders_clean
    GROUP BY 1
),
recency AS (
    SELECT
        customer_id,
        DATE_DIFF('day', last_order_date, (SELECT MAX(order_date) FROM orders_clean)) AS hari_sejak_order_terakhir
    FROM last_order
)
SELECT
    CASE
        WHEN hari_sejak_order_terakhir <= 90 THEN 'Aktif (<=90 hari)'
        WHEN hari_sejak_order_terakhir <= 180 THEN 'Mulai Pasif (91-180 hari)'
        WHEN hari_sejak_order_terakhir <= 365 THEN 'Berisiko Churn (181-365 hari)'
        ELSE 'Kemungkinan Churn (>365 hari)'
    END AS status_aktivitas,
    COUNT(*) AS jumlah_customer
FROM recency
GROUP BY 1
ORDER BY 2 DESC;

-- 3. New vs Repeat Customer per bulan
WITH first_order AS (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM orders_clean
    GROUP BY 1
)
SELECT
    DATE_TRUNC('month', o.order_date) AS bulan,
    SUM(CASE WHEN DATE_TRUNC('month', f.first_order_date) = DATE_TRUNC('month', o.order_date) THEN 1 ELSE 0 END) AS order_dari_customer_baru,
    SUM(CASE WHEN DATE_TRUNC('month', f.first_order_date) != DATE_TRUNC('month', o.order_date) THEN 1 ELSE 0 END) AS order_dari_customer_lama
FROM orders_clean o
JOIN first_order f ON o.customer_id = f.customer_id
GROUP BY 1
ORDER BY 1;

-- 4. Top Customer by Revenue (siapa kontributor terbesar)
SELECT
    customer_id,
    customer_segment,
    customer_city,
    customer_country,
    COUNT(DISTINCT order_id) AS total_order,
    ROUND(SUM(sales), 2) AS total_revenue
FROM orders_clean
GROUP BY 1, 2, 3, 4
ORDER BY total_revenue DESC
LIMIT 15;

-- 5. Order Frequency per Customer (rata-rata, buat baseline "normal")
SELECT
    ROUND(AVG(order_count), 2) AS avg_order_per_customer,
    MIN(order_count) AS min_order,
    MAX(order_count) AS max_order
FROM (
    SELECT customer_id, COUNT(DISTINCT order_id) AS order_count
    FROM orders_clean
    GROUP BY 1
);

-- Temuan:
-- - Segmentasi churn cukup berimbang: Kemungkinan Churn >365 hari (36%),
--   Aktif <=90 hari (28%), Mulai Pasif (18%), Berisiko Churn (17%)
--   -> wajar secara struktural karena banyak customer cuma order 1x
-- - ANOMALI BESAR: dari Nov 2017 s/d Jan 2018, 100% order berasal dari
--   "customer baru" (order_dari_customer_lama = 0 tiap bulan) -> mustahil
--   secara bisnis, indikasi cacat struktural di ekor dataset (customer_id
--   kemungkinan direset/tidak overlap dengan histori sebelumnya)
-- - Revenue Concentration konsisten dengan temuan sebelumnya: top customer
--   cuma ~7.031 dari total 23,27 juta (~0.03%)
-- - Rata-rata order per customer = 2.32, range 1-11, mayoritas cuma order 1x
--   -> base customer "sekali beli lalu hilang", bukan pola loyal distributor B2B

-- Kesimpulan:
-- - Jangan pakai data Nov 2017 - Jan 2018 untuk analisis New vs Repeat Customer
-- - Distributor Concentration Risk & Churn Rate TIDAK representatif di level
--   Customer untuk dataset ini -> demo konsep tsb lebih valid di level
--   Region atau Category
