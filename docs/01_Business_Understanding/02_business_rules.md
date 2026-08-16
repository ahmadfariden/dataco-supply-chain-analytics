# 1.2 Business Rules

## Tujuan
Menetapkan aturan bisnis dan status validitas untuk setiap metrik, berdasarkan hasil investigasi data pada tahap KPI Design dan EDA — memastikan hanya metrik yang teruji digunakan sebagai dasar insight bisnis.

## Input
Hasil investigasi KPI Design (1.1) dan EDA (3.1) terhadap tabel `orders_clean` / `fact_orders`.

## Proses Analisis
1. Menguji setiap metrik yang berpotensi bermasalah di berbagai dimensi (kategori, status, segment, waktu) untuk membedakan sinyal bisnis nyata dari noise/artifak data.
2. Menghitung korelasi statistik untuk mengonfirmasi temuan kualitatif (misalnya elastisitas diskon terhadap qty).
3. Mendokumentasikan setiap metrik sebagai VALID, TIDAK VALID, atau CAVEAT.

## Temuan
**TIDAK VALID:**
- `delivery_status`, `late_delivery_risk`, `shipping_days_actual` — deterministik dari `shipping_mode` (First Class selalu tepat 2 hari, 0 variasi natural, korelasi scheduled-actual hanya 0.52 karena loncatan antar mode).
- `discount_rate`, `discount_amount` — tidak ada elastisitas terhadap qty maupun profit (korelasi ≈ -0.002 dan -0.02).
- Order loss rate ~18-19% — merata di semua dimensi (kategori, status, segment, shipping mode), pola random bukan masalah bisnis spesifik.
- Revenue Concentration by Customer — Top 10 customer hanya 0,28% dari total revenue, tidak representatif untuk konsep Distributor Concentration Risk.
- New vs Repeat Customer periode Nov 2017 - Jan 2018 — customer_id tidak overlap dengan histori sebelumnya (100% tercatat "customer baru"), indikasi cacat struktural di ekor dataset.

**CAVEAT:**
- Data order_date 2018 hanya tersedia Januari — exclude dari perbandingan YoY.

**VALID:**
- `sales`, `benefit_per_order`, `order_region`, `market`, `category_name`, `product_name`, `order_status` — konsisten di seluruh pengecekan.
- Product Growth 2016 vs 2017 — konsisten dengan tren revenue total (-38%), signal bisnis nyata.

## Output
Tabel `data_quality_flags` (6 finding: DQ-01 s/d DQ-06) dengan kolom finding_id, category, issue_description, severity, business_impact, recommendation — digunakan sebagai rujukan validitas di seluruh tahap analisis dan dashboard berikutnya.

## Kesimpulan
4 dari 6 layer KPI (Revenue, Region, Customer volume, Product Growth) valid digunakan untuk insight bisnis. 2 layer (Delivery/OTIF, efektivitas Promosi) terbukti mengandung pola artifisial dan tidak boleh dijadikan dasar keputusan bisnis. Aturan ini mengikat seluruh tahapan analisis selanjutnya.
