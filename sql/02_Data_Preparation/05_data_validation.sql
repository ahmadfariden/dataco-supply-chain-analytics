-- ============================================================
-- DATA VALIDATION
-- Tujuan: Cek konsistensi bisnis pada orders_clean sebelum dipakai untuk KPI
-- ============================================================

-- ----- ANOMALI 1: shipping_date harus >= order_date -----

SELECT COUNT(*) AS anomali_tanggal
FROM orders_clean
WHERE shipping_date < order_date;

-- ----- ANOMALI 2: shipping_days_actual harus konsisten dengan selisih tanggal riil -----

SELECT
    shipping_days_actual,
    DATE_DIFF('day', order_date, shipping_date) AS hitung_manual,
    COUNT(*) AS jumlah
FROM orders_clean
WHERE shipping_days_actual != DATE_DIFF('day', order_date, shipping_date)
GROUP BY 1, 2
ORDER BY jumlah DESC
LIMIT 10;

-- ----- ANOMALI 3: late_delivery_risk harus konsisten dengan delivery_status -----

SELECT delivery_status, late_delivery_risk, COUNT(*) AS jumlah
FROM orders_clean
GROUP BY 1, 2
ORDER BY 1, 2;

-- ----- ANOMALI 4: nilai bisnis yang tidak masuk akal (sales/harga/qty <= 0, discount rate di luar 0-1) -----

SELECT
    SUM(CASE WHEN sales <= 0 THEN 1 ELSE 0 END) AS sales_invalid,
    SUM(CASE WHEN product_price <= 0 THEN 1 ELSE 0 END) AS price_invalid,
    SUM(CASE WHEN order_qty <= 0 THEN 1 ELSE 0 END) AS qty_invalid,
    SUM(CASE WHEN discount_rate < 0 OR discount_rate > 1 THEN 1 ELSE 0 END) AS discount_rate_invalid
FROM orders_clean;

-- ----- ANOMALI 5: rentang profit_ratio wajar atau tidak -----

SELECT MIN(profit_ratio) AS min_ratio, MAX(profit_ratio) AS max_ratio, AVG(profit_ratio) AS avg_ratio
FROM orders_clean;

-- Temuan:
-- - 0 anomali tanggal (shipping selalu >= order date)
-- - 0 mismatch antara shipping_days_actual dan hitungan manual selisih tanggal -> 100% konsisten
-- - late_delivery_risk konsisten dengan delivery_status:
--     Late delivery -> selalu risk = 1 (62.712 baris)
--     Advance shipping / Shipping on time / Shipping canceled -> selalu risk = 0
-- - 0 nilai invalid di sales, price, qty, discount_rate
-- - profit_ratio range -2.75 s/d 0.5, rata-rata 0.12
--   -> bukan data kotor, tapi temuan bisnis: ada order yang rugi cukup dalam,
--      layak dicermati lagi saat KPI Margin/Profit (Sheet 5)
--
-- KESIMPULAN KESELURUHAN STEP 8-12:
-- Dataset bersih dan tervalidasi, siap dipakai untuk KPI Design (Step 13).
-- Temuan bisnis yang perlu ditindaklanjuti: 55% order berstatus "Late delivery"
-- (62.712 dari 114.187 baris) -- sinyal kuat untuk eksplorasi OTIF/Stockout.
