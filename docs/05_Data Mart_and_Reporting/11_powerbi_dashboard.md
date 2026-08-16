# 5.2 Power BI Dashboard

## Tujuan
Membangun dashboard interaktif di Power BI Desktop berbasis Star Schema, dengan visual yang hanya menggunakan metrik VALID sesuai Business Rules, dilengkapi insight card kontekstual di tiap halaman.

## Input
7 file Parquet (`fact_orders`, `dim_customer`, `dim_product`, `dim_region`, `dim_date`, `dim_shipping`, `data_quality_flags`)

## Proses Analisis
1. Mengimpor seluruh file Parquet ke Power BI, menyusun relasi model sesuai Star Schema (5 relasi one-to-many dari dimension ke fact table).
2. Konfigurasi model: `dim_date` di-mark sebagai Date Table; kolom numerik di `dim_date` diubah ke "Do not summarize"; seluruh surrogate key di-hide dari report view.
3. Membuat 12 DAX measure inti: Total Revenue, Total Profit, Total Orders, Total Customers, AOV, Profit Margin %, Total Regions, Total Categories, Total Quantity Sold, Revenue 2016, Revenue 2017, Growth % (2016 vs 2017 khusus, bukan time intelligence generik karena data 2015 & 2018 tidak lengkap).
4. Membangun 3 halaman dashboard: Executive Overview, Region & Customer Analysis, Product & Category Analysis — masing-masing dengan KPI card, chart, slicer, dan (untuk Page 2 & 3) tabel detail dengan conditional formatting.
5. Menambahkan insight card naratif (Finding-Root Cause-Action-Impact) di tiap halaman terkait, alih-alih halaman Data Quality Notes terpisah.

## Temuan
- Model berhasil dibangun tanpa error setelah 3 perbaikan konfigurasi (Date Table marking, summarization kolom tanggal, hide surrogate key).
- Isu granularity chart tren revenue (axis `full_date` tanpa hierarki drill karena Date Table marking mematikan hierarki otomatis) diselesaikan dengan axis manual (`year` + `month_name`), memerlukan perbaikan tambahan pada tipe data `month_number` (awalnya ter-detect sebagai Text sehingga sorting salah) dan Sort by Column pada `month_name`.
- 4 insight card berhasil dibangun: Revenue Decline 2016-2017 (digabung dengan caveat Jan 2018), Customer Base is Highly Dispersed, High Margin ≠ High Impact.

## Output
Dashboard Power BI 3 halaman aktif (Executive Overview, Region & Customer Analysis, Product & Category Analysis), terhubung langsung ke Star Schema, dengan insight naratif terintegrasi di tiap halaman.

## Kesimpulan
Halaman Data Quality Notes terpisah (semula direncanakan sebagai Page 4) tidak dibangun sebagai halaman mandiri — fungsinya digantikan oleh insight card yang tersebar di tiap halaman terkait. Konsekuensinya, 3 dari 6 temuan `data_quality_flags` (DQ-01 delivery, DQ-02 discount, DQ-06 loss rate) tidak memiliki representasi visual di dashboard karena field terkait memang tidak dipakai di visual manapun; temuan tersebut tetap terdokumentasi lengkap di tabel `data_quality_flags` dan dokumen project ini.
