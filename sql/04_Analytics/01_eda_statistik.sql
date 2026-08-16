-- ============================================================
-- EDA STATISTIK
-- Tujuan: Statistik deskriptif, outlier, dan korelasi antar variabel numerik
-- ============================================================

-- 1. Descriptive statistics untuk kolom numerik utama
SELECT
    'sales' AS kolom,
    ROUND(MIN(sales), 2) AS min_val,
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sales), 2) AS q1,
    ROUND(MEDIAN(sales), 2) AS median,
    ROUND(AVG(sales), 2) AS mean,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sales), 2) AS q3,
    ROUND(MAX(sales), 2) AS max_val,
    ROUND(STDDEV(sales), 2) AS stddev
FROM orders_clean
UNION ALL
SELECT
    'order_qty',
    MIN(order_qty), 
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY order_qty),
    MEDIAN(order_qty),
    ROUND(AVG(order_qty), 2),
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY order_qty),
    MAX(order_qty),
    ROUND(STDDEV(order_qty), 2)
FROM orders_clean
UNION ALL
SELECT
    'benefit_per_order',
    ROUND(MIN(benefit_per_order), 2),
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY benefit_per_order), 2),
    ROUND(MEDIAN(benefit_per_order), 2),
    ROUND(AVG(benefit_per_order), 2),
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY benefit_per_order), 2),
    ROUND(MAX(benefit_per_order), 2),
    ROUND(STDDEV(benefit_per_order), 2)
FROM orders_clean
UNION ALL
SELECT
    'product_price',
    ROUND(MIN(product_price), 2),
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY product_price), 2),
    ROUND(MEDIAN(product_price), 2),
    ROUND(AVG(product_price), 2),
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY product_price), 2),
    ROUND(MAX(product_price), 2),
    ROUND(STDDEV(product_price), 2)
FROM orders_clean;

-- 2. Deteksi Outlier pakai IQR method (khusus kolom sales)
WITH stats AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sales) AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sales) AS q3
    FROM orders_clean
),
bounds AS (
    SELECT
        q1, q3,
        q3 - q1 AS iqr,
        q1 - 1.5 * (q3 - q1) AS lower_bound,
        q3 + 1.5 * (q3 - q1) AS upper_bound
    FROM stats
)
SELECT
    (SELECT lower_bound FROM bounds) AS batas_bawah,
    (SELECT upper_bound FROM bounds) AS batas_atas,
    COUNT(*) AS jumlah_outlier,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders_clean), 2) AS pct_outlier
FROM orders_clean, bounds
WHERE sales < bounds.lower_bound OR sales > bounds.upper_bound;

-- 3. Korelasi antar variabel numerik
SELECT
    ROUND(CORR(order_qty, sales), 4) AS corr_qty_sales,
    ROUND(CORR(product_price, sales), 4) AS corr_price_sales,
    ROUND(CORR(discount_rate, order_qty), 4) AS corr_discount_qty,
    ROUND(CORR(discount_rate, benefit_per_order), 4) AS corr_discount_profit,
    ROUND(CORR(sales, benefit_per_order), 4) AS corr_sales_profit,
    ROUND(CORR(shipping_days_scheduled, shipping_days_actual), 4) AS corr_scheduled_actual
FROM orders_clean;

-- 4. Distribusi jumlah item per order (order size)
SELECT
    item_per_order,
    COUNT(*) AS jumlah_order
FROM (
    SELECT order_id, COUNT(*) AS item_per_order
    FROM orders_clean
    GROUP BY 1
)
GROUP BY 1
ORDER BY 1;

-- 5. Variabilitas revenue antar kategori
SELECT
    category_name,
    COUNT(*) AS jumlah_order,
    ROUND(AVG(sales), 2) AS avg_sales,
    ROUND(STDDEV(sales), 2) AS stddev_sales,
    ROUND(STDDEV(sales) / NULLIF(AVG(sales),0), 2) AS coef_variation
FROM orders_clean
GROUP BY 1
HAVING COUNT(*) >= 100
ORDER BY coef_variation DESC
LIMIT 10;

-- Temuan:
-- - sales: median 199.92 vs mean 203.78 (relatif simetris)
-- - product_price: mean (141.99) jauh di atas median (59.99) -> right-skewed
--   (ada segelintir produk mahal yang narik rata-rata ke atas)
-- - benefit_per_order min -4274.98 -> outlier ekstrem, layak diselidiki terpisah
-- - Outlier sales (IQR method): cuma 0.28% (325 dari 114.187 baris) -> data cukup bersih
-- - corr_price_sales = 0.7956 -> kuat & masuk akal
-- - corr_discount_qty = -0.0022 -> PRAKTIS NOL -> bukti matematis: diskon TIDAK
--   mempengaruhi qty pembelian (konfirmasi ulang temuan Step 13)
-- - corr_discount_profit = -0.0211 -> PRAKTIS NOL -> diskon juga tidak berkorelasi ke profit
-- - corr_scheduled_actual = 0.5188 -> moderat, bukan 1.0 sempurna, konsisten dengan
--   pola deterministik PER shipping_mode (bukan hubungan linear seragam)
-- - item_per_order terdistribusi rata (~7.200 di tiap kategori 2-5 item),
--   sedikit "terlalu rapi" dibanding pola order riil yang biasanya skewed
-- - Coefficient of variation tertinggi: Lacrosse (0.96), Fitness Accessories (0.9)

-- Kesimpulan:
-- Korelasi memberi bukti matematis (bukan cuma observasi manual) yang mengonfirmasi
-- temuan noise di Step 13: discount_rate dan shipping_days_actual terbukti tidak
-- punya hubungan sebab-akibat yang wajar terhadap qty/profit/waktu pengiriman riil.
