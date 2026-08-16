-- ============================================================
-- STEP 14 — BUSINESS RULES
-- Tujuan: Dokumentasikan aturan bisnis & status validitas tiap metrik,
--         berdasarkan temuan Step 12-13
-- ============================================================

-- Tidak ada query baru di step ini — murni dokumentasi/rangkuman.
-- Aturan-aturan berikut jadi acuan untuk semua step selanjutnya.

-- ----- ATURAN VALID (aman dipakai untuk insight bisnis) -----
-- sales                -> Total Revenue = SUM(sales)
-- benefit_per_order     -> Profit per order-item, bisa negatif
-- order_region / market -> level geografis, market = agregat lebih tinggi
-- customer_segment      -> 3 kategori: Consumer, Corporate, Home Office
-- category_name/product_name -> valid untuk growth, contribution, dead SKU
-- order_date             -> valid 2015-01-01 s/d 2018-01-31
--                           (2018 cuma 1 bulan -> exclude dari YoY/tren)
-- Revenue growth 2016->2017 per produk -> SIGNAL BISNIS NYATA (bukan noise)

-- ----- ATURAN TIDAK VALID (terbukti artifisial, lihat Step 13) -----
-- late_delivery_risk, delivery_status, shipping_days_actual
--   -> deterministik dari shipping_mode (First Class selalu 2 hari, 0 variasi)
--   -> JANGAN dipakai untuk klaim "region/kategori mana paling sering telat"
--
-- Order-level loss rate (~18-19%)
--   -> konsisten merata di SEMUA dimensi (kategori, status, diskon, segment, shipping)
--   -> JANGAN dipakai untuk klaim "kategori X boros/rugi"
--   -> kalau butuh insight profitabilitas, pakai TOTAL PROFIT per kategori (angka absolut)

-- ----- RULE TAMBAHAN (DEFINISI KERJA) -----
-- Active Customer (bulan ini)  = COUNT(DISTINCT customer_id) dalam periode
-- Revenue Concentration        = % revenue dari Top N customer terhadap total revenue
--                                 (di dataset ini sangat rendah/0.28% -> unit analisis
--                                 Customer TIDAK cocok untuk Concentration Risk;
--                                 pakai Region atau Category sebagai ganti)
-- Product Growth                = (Revenue tahun ini - Revenue tahun lalu) / Revenue tahun lalu
--                                 Gunakan 2016 vs 2017 saja (2015 & 2018 tidak lengkap)
-- Dead/Slow SKU (proxy)         = Produk dengan total_qty terendah secara absolut
--                                 (dataset tidak punya kolom "hari sejak last sold")

-- Temuan:
-- - 4 dari 6 layer KPI (Revenue, Region, Customer volume, Product growth) VALID
-- - 2 layer (Delivery/OTIF, sebagian Financial) punya cacat data sintetis
-- - Tidak ada data untuk: Forecast Accuracy, Stock Availability (gudang),
--   Distributor Satisfaction, Dead Stock % (definisi asli), Bad Debt Risk
--   -> ini gap struktural dataset, bukan masalah kualitas data

-- Kesimpulan:
-- Dataset DataCo layak untuk latihan SQL end-to-end (loading, cleaning, validation,
-- KPI design, deteksi anomali), tapi punya keterbatasan nyata sebagai bahan insight
-- bisnis "real" di area delivery/OTIF dan sebagian profitabilitas.
-- Insight paling aman & kuat untuk cerita analisis: Revenue trend, Region performance,
-- Product growth 2016->2017, Product/Category mix.
