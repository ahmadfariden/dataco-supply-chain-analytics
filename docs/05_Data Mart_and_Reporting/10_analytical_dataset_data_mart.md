# 5.1 Analytical Dataset & Data Mart

## Tujuan
Membangun tabel-tabel agregat siap pakai untuk dashboard/reporting, difokuskan pada metrik yang telah tervalidasi, sekaligus menyediakan tabel dokumentasi kualitas data yang terintegrasi dengan Star Schema.

## Input
`fact_orders` dan 5 dimension table (hasil Data Transformation)

## Proses Analisis
1. Membangun mart agregat: `mart_revenue_monthly`, `mart_region_performance`, `mart_product_performance`, `mart_category_summary`, `mart_customer_summary`.
2. Membangun tabel `data_quality_flags` dengan struktur `finding_id`, `category`, `issue_description`, `severity`, `business_impact`, `recommendation` — merangkum 6 temuan (DQ-01 s/d DQ-06) dari Business Rules, disinkronkan agar merujuk langsung ke kolom di Star Schema (bukan lagi ke `orders_clean` flat).
3. Meng-export seluruh `fact_orders`, dimension table, dan `data_quality_flags` ke format Parquet untuk konsumsi Power BI.

## Temuan
- Seluruh mart berhasil dibangun tanpa error, row count konsisten dengan angka yang telah divalidasi di tahap-tahap sebelumnya.
- `data_quality_flags` versi final berisi 6 finding dengan distribusi severity: 2 High (delivery performance, customer data integrity), 2 Medium (promotion effectiveness, order loss rate), 2 Low (revenue concentration, data completeness).
- Ekspor ke Parquet menghasilkan file yang jauh lebih ringkas dibanding CSV (`fact_orders.parquet` ~3MB untuk 114.187 baris x 19 kolom) berkat kompresi columnar.

## Output
- 5 tabel mart agregat + 1 tabel `data_quality_flags` (struktur final)
- 7 file Parquet (`fact_orders` + 5 dimension + `data_quality_flags`) siap diimpor ke Power BI

## Kesimpulan
Data Mart Layer melengkapi struktur database menjadi 4 lapis (Raw → Clean → Star Schema → Mart). Tabel `data_quality_flags` berfungsi sebagai safety net permanen — siapa pun yang mengakses model ini di Power BI dapat langsung mengetahui batasan dan validitas tiap metrik tanpa perlu membaca ulang seluruh proses investigasi.
