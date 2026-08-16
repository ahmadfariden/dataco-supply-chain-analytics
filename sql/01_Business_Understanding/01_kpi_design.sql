-- ===== 1. REVENUE LAYER (Sheet 1) =====

SELECT ROUND(SUM(sales), 2) AS total_revenue FROM orders_clean;

SELECT
    DATE_TRUNC('month', order_date) AS bulan,
    ROUND(SUM(sales), 2) AS revenue
FROM orders_clean
GROUP BY 1
ORDER BY 1;

SELECT
    DATE_TRUNC('year', order_date) AS tahun,
    ROUND(SUM(sales), 2) AS revenue
FROM orders_clean
GROUP BY 1
ORDER BY 1;

-- ===== 2. REGION LAYER (Sheet 2) =====

SELECT
    order_region,
    ROUND(SUM(sales), 2) AS revenue,
    ROUND(SUM(sales) * 100.0 / SUM(SUM(sales)) OVER (), 2) AS pct_kontribusi
FROM orders_clean
GROUP BY 1
ORDER BY revenue DESC;

SELECT market, ROUND(SUM(sales), 2) AS revenue
FROM orders_clean
GROUP BY 1
ORDER BY revenue DESC;

-- ===== 3. DISTRIBUTOR/CUSTOMER LAYER (Sheet 2) =====

SELECT
    DATE_TRUNC('month', order_date) AS bulan,
    COUNT(DISTINCT customer_id) AS active_customer
FROM orders_clean
GROUP BY 1
ORDER BY 1;

WITH per_customer AS (
    SELECT customer_id, SUM(sales) AS revenue
    FROM orders_clean
    GROUP BY 1
),
ranked AS (
    SELECT *, RANK() OVER (ORDER BY revenue DESC) AS rnk
    FROM per_customer
)
SELECT
    SUM(CASE WHEN rnk <= 10 THEN revenue ELSE 0 END) AS revenue_top10,
    SUM(revenue) AS total_revenue,
    ROUND(SUM(CASE WHEN rnk <= 10 THEN revenue ELSE 0 END) * 100.0 / SUM(revenue), 2) AS pct_top10
FROM ranked;

SELECT
    customer_segment,
    COUNT(DISTINCT customer_id) AS jumlah_customer,
    ROUND(SUM(sales), 2) AS revenue
FROM orders_clean
GROUP BY 1
ORDER BY revenue DESC;

-- ===== 4. DELIVERY / OTIF LAYER (Sheet 3) =====

SELECT
    delivery_status,
    COUNT(*) AS jumlah,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM orders_clean
GROUP BY 1
ORDER BY jumlah DESC;

SELECT
    DATE_TRUNC('month', order_date) AS bulan,
    ROUND(AVG(late_delivery_risk) * 100.0, 2) AS pct_late_delivery
FROM orders_clean
GROUP BY 1
ORDER BY 1;

SELECT
    order_region,
    ROUND(AVG(late_delivery_risk) * 100.0, 2) AS pct_late_delivery,
    COUNT(*) AS jumlah_order
FROM orders_clean
GROUP BY 1
ORDER BY pct_late_delivery DESC;

-- ===== 5. PRODUCT LAYER (Sheet 4) =====

SELECT
    category_name,
    ROUND(SUM(sales), 2) AS revenue,
    ROUND(SUM(sales) * 100.0 / SUM(SUM(sales)) OVER (), 2) AS pct_kontribusi
FROM orders_clean
GROUP BY 1
ORDER BY revenue DESC;

SELECT
    product_name,
    ROUND(SUM(sales), 2) AS revenue,
    SUM(order_qty) AS total_qty
FROM orders_clean
GROUP BY 1
ORDER BY revenue DESC
LIMIT 10;

-- ===== 6. FINANCIAL LAYER (Sheet 5) =====

SELECT
    ROUND(SUM(benefit_per_order), 2) AS total_profit,
    ROUND(AVG(profit_ratio), 4) AS avg_profit_ratio,
    ROUND(SUM(CASE WHEN benefit_per_order < 0 THEN benefit_per_order ELSE 0 END), 2) AS total_kerugian_dari_order_rugi,
    SUM(CASE WHEN benefit_per_order < 0 THEN 1 ELSE 0 END) AS jumlah_order_rugi
FROM orders_clean;

SELECT
    category_name,
    ROUND(SUM(benefit_per_order), 2) AS total_profit,
    ROUND(AVG(profit_ratio), 4) AS avg_profit_ratio
FROM orders_clean
GROUP BY 1
ORDER BY total_profit DESC;

-- Query lanjutan investigasi (dari diskusi setelah hasil awal keluar)

SELECT
    order_status,
    SUM(benefit_per_order) AS total_profit,
    COUNT(*) AS jumlah
FROM orders_clean
GROUP BY 1
ORDER BY total_profit ASC;

SELECT
    category_name,
    SUM(CASE WHEN benefit_per_order < 0 THEN benefit_per_order ELSE 0 END) AS total_kerugian,
    SUM(CASE WHEN benefit_per_order < 0 THEN 1 ELSE 0 END) AS jumlah_order_rugi,
    COUNT(*) AS total_order,
    ROUND(SUM(CASE WHEN benefit_per_order < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_order_rugi
FROM orders_clean
GROUP BY 1
ORDER BY total_kerugian ASC
LIMIT 15;

SELECT
    CASE 
        WHEN discount_rate = 0 THEN '0% (no discount)'
        WHEN discount_rate <= 0.1 THEN '1-10%'
        WHEN discount_rate <= 0.2 THEN '11-20%'
        WHEN discount_rate <= 0.3 THEN '21-30%'
        ELSE '>30%'
    END AS bucket_discount,
    COUNT(*) AS total_order,
    SUM(CASE WHEN benefit_per_order < 0 THEN 1 ELSE 0 END) AS jumlah_rugi,
    ROUND(SUM(CASE WHEN benefit_per_order < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_rugi,
    ROUND(AVG(benefit_per_order), 2) AS avg_profit_per_order
FROM orders_clean
GROUP BY 1
ORDER BY 1;

SELECT
    customer_segment,
    COUNT(*) AS total_order,
    ROUND(SUM(CASE WHEN benefit_per_order < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_rugi
FROM orders_clean
GROUP BY 1;

SELECT
    shipping_mode,
    COUNT(*) AS total_order,
    ROUND(SUM(CASE WHEN benefit_per_order < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_rugi
FROM orders_clean
GROUP BY 1;

-- Investigasi Product & Delivery lanjutan

SELECT
    product_name,
    SUM(CASE WHEN EXTRACT(year FROM order_date) = 2016 THEN sales ELSE 0 END) AS revenue_2016,
    SUM(CASE WHEN EXTRACT(year FROM order_date) = 2017 THEN sales ELSE 0 END) AS revenue_2017,
    ROUND(
        (SUM(CASE WHEN EXTRACT(year FROM order_date) = 2017 THEN sales ELSE 0 END)
        - SUM(CASE WHEN EXTRACT(year FROM order_date) = 2016 THEN sales ELSE 0 END))
        * 100.0 / NULLIF(SUM(CASE WHEN EXTRACT(year FROM order_date) = 2016 THEN sales ELSE 0 END), 0)
    , 2) AS pct_growth
FROM orders_clean
GROUP BY 1
HAVING SUM(CASE WHEN EXTRACT(year FROM order_date) = 2016 THEN sales ELSE 0 END) > 0
ORDER BY pct_growth DESC
LIMIT 15;

SELECT
    product_name,
    SUM(order_qty) AS total_qty,
    COUNT(*) AS jumlah_transaksi,
    ROUND(SUM(sales), 2) AS revenue
FROM orders_clean
GROUP BY 1
ORDER BY total_qty ASC
LIMIT 15;

SELECT
    product_name,
    ROUND(SUM(sales), 2) AS revenue,
    COUNT(*) AS jumlah_transaksi,
    ROUND(SUM(sales) / COUNT(*), 2) AS revenue_per_transaksi
FROM orders_clean
GROUP BY 1
HAVING COUNT(*) >= 10
ORDER BY revenue_per_transaksi DESC
LIMIT 15;

SELECT
    ROUND(AVG(shipping_days_actual - shipping_days_scheduled), 2) AS avg_selisih_hari,
    ROUND(AVG(shipping_days_actual), 2) AS avg_actual,
    ROUND(AVG(shipping_days_scheduled), 2) AS avg_scheduled
FROM orders_clean;

SELECT
    shipping_mode,
    ROUND(AVG(shipping_days_actual - shipping_days_scheduled), 2) AS avg_selisih_hari,
    ROUND(AVG(late_delivery_risk) * 100, 2) AS pct_late,
    COUNT(*) AS jumlah_order
FROM orders_clean
GROUP BY 1
ORDER BY pct_late DESC;

SELECT
    category_name,
    ROUND(AVG(late_delivery_risk) * 100, 2) AS pct_late,
    COUNT(*) AS jumlah_order
FROM orders_clean
GROUP BY 1
ORDER BY pct_late DESC
LIMIT 10;

-- Konfirmasi anomali shipping mode (bukti deterministik)
SELECT
    shipping_mode,
    ROUND(AVG(shipping_days_scheduled), 2) AS avg_scheduled,
    ROUND(AVG(shipping_days_actual), 2) AS avg_actual,
    COUNT(*) AS jumlah_order
FROM orders_clean
GROUP BY 1
ORDER BY avg_scheduled;

SELECT
    shipping_mode,
    shipping_days_actual,
    COUNT(*) AS jumlah
FROM orders_clean
WHERE shipping_mode = 'First Class'
GROUP BY 1, 2
ORDER BY 2;

-- Temuan:
-- - Total Revenue: 23.269.429 | 2018 cuma 1 bulan data (Januari), exclude dari YoY
-- - Western Europe region terbesar (15.85%), distribusi region cukup merata
-- - Revenue Concentration by Customer sangat rendah (Top 10 cuma 0.28%) -> tidak
--   representatif untuk konsep Distributor Concentration Risk
-- - Late delivery rate 54.92% konsisten tiap bulan (53-58%) -> masalah struktural,
--   TAPI terbukti deterministik dari shipping_mode (lihat query terakhir):
--   First Class SELALU shipping_days_actual = 2, tanpa variasi sama sekali (0 stddev)
--   -> jangan dipakai sebagai insight OTIF riil
-- - ~19% order rugi, TAPI rate ini merata di semua dimensi (kategori, status,
--   discount, segment, shipping mode) -> pola random/noise, bukan masalah bisnis spesifik
-- - Semua Order Status tetap profit positif (termasuk CANCELED & SUSPECTED_FRAUD)
-- - Product Growth 2016->2017: penurunan nyata & konsisten (~-38% total revenue,
--   -50% s/d -80% di top produk) -> ini SIGNAL BISNIS VALID, bukan noise
