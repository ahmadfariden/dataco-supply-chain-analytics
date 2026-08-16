-- ============================================================
-- STEP 27 — PARQUET OPTIMIZATION LAYER
-- Tujuan: Export orders_clean & seluruh mart ke format Parquet
--         (siap dipakai untuk Power BI / Step 29-30)
-- ============================================================

-- Catatan: folder tujuan harus sudah dibuat lebih dulu di OS
-- (DuckDB tidak bisa membuat folder sendiri), contoh:
-- mkdir "C:\Users\ahmad farid\Downloads\FMCG\latihan sql DataCo\export_parquet"

COPY orders_clean TO 'C:\Users\ahmad farid\Downloads\FMCG\latihan sql DataCo\export_parquet\orders_clean.parquet' (FORMAT PARQUET);

COPY mart_revenue_monthly TO 'C:\Users\ahmad farid\Downloads\FMCG\latihan sql DataCo\export_parquet\mart_revenue_monthly.parquet' (FORMAT PARQUET);

COPY mart_region_performance TO 'C:\Users\ahmad farid\Downloads\FMCG\latihan sql DataCo\export_parquet\mart_region_performance.parquet' (FORMAT PARQUET);

COPY mart_product_performance TO 'C:\Users\ahmad farid\Downloads\FMCG\latihan sql DataCo\export_parquet\mart_product_performance.parquet' (FORMAT PARQUET);

COPY mart_category_summary TO 'C:\Users\ahmad farid\Downloads\FMCG\latihan sql DataCo\export_parquet\mart_category_summary.parquet' (FORMAT PARQUET);

COPY mart_customer_summary TO 'C:\Users\ahmad farid\Downloads\FMCG\latihan sql DataCo\export_parquet\mart_customer_summary.parquet' (FORMAT PARQUET);

COPY data_quality_flags TO 'C:\Users\ahmad farid\Downloads\FMCG\latihan sql DataCo\export_parquet\data_quality_flags.parquet' (FORMAT PARQUET);

-- Cek semua file berhasil ke-generate
SELECT * FROM glob('C:\Users\ahmad farid\Downloads\FMCG\latihan sql DataCo\export_parquet\*');

-- Temuan:
-- 7 file .parquet berhasil diexport (orders_clean + 5 mart + data_quality_flags)

-- Kesimpulan:
-- Parquet dipilih karena format kolomer (columnar) -> ukuran file lebih kecil
-- (biasanya 5-10x lebih kecil dari CSV) dan query lebih cepat karena hanya
-- membaca kolom yang dibutuhkan. Siap dikoneksikan ke Power BI (Step 29-30).
