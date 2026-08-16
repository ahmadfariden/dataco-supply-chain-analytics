-- ============================================================
-- PROMOTION ANALYSIS
-- Tujuan: Analisis efektivitas promosi (proxy: discount_rate) terhadap
--         Revenue dan Profit
-- Catatan: dataset TIDAK punya kolom promosi eksplisit. discount_rate/
--          discount_amount dipakai sebagai proxy aktivitas promosi.
-- ============================================================

-- 1. Overview: Promo (ada diskon) vs Non-Promo (tanpa diskon)
SELECT
    CASE WHEN discount_rate > 0 THEN 'Promo (ada diskon)' ELSE 'Non-Promo' END AS status_promo,
    COUNT(*) AS jumlah_order,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(AVG(sales), 2) AS avg_revenue_per_order,
    ROUND(AVG(order_qty), 2) AS avg_qty_per_order,
    ROUND(SUM(benefit_per_order), 2) AS total_profit,
    ROUND(AVG(profit_ratio), 4) AS avg_profit_ratio
FROM orders_clean
GROUP BY 1;

-- 2. Efektivitas promosi per level diskon
SELECT
    CASE 
        WHEN discount_rate = 0 THEN '0% (no discount)'
        WHEN discount_rate <= 0.1 THEN '1-10%'
        WHEN discount_rate <= 0.2 THEN '11-20%'
        WHEN discount_rate <= 0.3 THEN '21-30%'
        ELSE '>30%'
    END AS bucket_discount,
    COUNT(*) AS jumlah_order,
    ROUND(AVG(order_qty), 2) AS avg_qty,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(benefit_per_order), 2) AS total_profit,
    ROUND(SUM(benefit_per_order) / NULLIF(SUM(sales),0) * 100, 2) AS margin_pct
FROM orders_clean
GROUP BY 1
ORDER BY 1;

-- 3. Trend pemakaian diskon dari waktu ke waktu
SELECT
    DATE_TRUNC('month', order_date) AS bulan,
    ROUND(AVG(discount_rate) * 100, 2) AS avg_discount_pct,
    ROUND(SUM(CASE WHEN discount_rate > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_order_pakai_promo
FROM orders_clean
GROUP BY 1
ORDER BY 1;

-- 4. Kategori mana yang paling sering "dipromosikan"
SELECT
    category_name,
    COUNT(*) AS jumlah_order,
    ROUND(AVG(discount_rate) * 100, 2) AS avg_discount_pct,
    ROUND(SUM(CASE WHEN discount_rate > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_order_pakai_promo
FROM orders_clean
GROUP BY 1
ORDER BY avg_discount_pct DESC
LIMIT 15;

-- 5. Elastisitas — apakah diskon besar berkorelasi dengan qty lebih besar?
SELECT
    ROUND(discount_rate, 1) AS discount_rate_rounded,
    COUNT(*) AS jumlah_order,
    ROUND(AVG(order_qty), 2) AS avg_qty
FROM orders_clean
GROUP BY 1
ORDER BY 1;

-- Temuan:
-- - avg_qty_per_order HAMPIR IDENTIK di semua level diskon (2.11 - 2.13),
--   termasuk 0% vs 30% diskon -> TIDAK ADA elastisitas sama sekali
-- - avg_discount_pct per bulan sangat stabil (~9.9%-10.4%) selama 37 bulan
--   -> tidak ada pola musiman/high season promo
-- - pct_order_pakai_promo juga stabil ~94% tiap bulan, tanpa variasi strategi
-- - Margin turun seiring diskon makin dalam (12.86% -> 8.96%) -> ini cuma efek
--   aritmatika (diskon motong revenue), bukan bukti strategi promosi berhasil/gagal
-- - Dikonfirmasi matematis di Step 19: corr(discount_rate, order_qty) = -0.0022,
--   corr(discount_rate, benefit_per_order) = -0.0211 -> praktis nol

-- Kesimpulan:
-- discount_rate & discount_amount adalah NOISE, bukan sinyal promosi bisnis riil.
-- Kemungkinan besar di-generate random independen dari qty/kategori/waktu.
-- JANGAN dipakai untuk klaim "Promosi efektif menaikkan Revenue/Qty" (Sheet 1).
