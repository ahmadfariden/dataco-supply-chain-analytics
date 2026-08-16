# 2.2 Data Cleaning & Validation

## Tujuan
Membangun tabel bersih dengan tipe data yang benar dan nama kolom yang rapi, kemudian memvalidasi konsistensi logis antar kolom sebelum data dipercaya untuk perhitungan KPI.

## Input
Tabel `orders` (mentah, hasil Data Collection & Profiling)

## Proses Analisis
1. `CREATE TABLE orders_clean` dengan `CAST` untuk kolom numerik (INTEGER/DOUBLE) dan `STRPTIME` untuk kolom tanggal, serta rename seluruh kolom ke snake_case.
2. Verifikasi jumlah baris tetap sama dengan tabel sumber (memastikan tidak ada baris hilang).
3. Validasi konsistensi bisnis: `shipping_date` >= `order_date`, kecocokan `shipping_days_actual` dengan selisih tanggal riil, kecocokan `late_delivery_risk` dengan `delivery_status`, nilai bisnis yang tidak masuk akal (sales/harga/qty ≤ 0, discount_rate di luar 0-1), rentang `profit_ratio`.

## Temuan
- **114.187 baris** berhasil masuk ke `orders_clean`, identik dengan tabel sumber — tidak ada baris hilang selama cleaning.
- Seluruh 29 kolom bertipe data benar (INTEGER, DOUBLE, VARCHAR, TIMESTAMP), nama kolom konsisten snake_case.
- **0 anomali tanggal** — shipping selalu terjadi setelah order dibuat.
- **0 mismatch** antara `shipping_days_actual` dan hitungan manual selisih tanggal — 100% konsisten secara matematis (meski nantinya terbukti deterministik dari shipping_mode, lihat Business Rules).
- `late_delivery_risk` konsisten dengan `delivery_status` — hanya status "Late delivery" (62.712 baris) yang punya risk=1.
- **0 nilai invalid** pada sales, price, qty, discount_rate.
- `profit_ratio` berkisar -2,75 s/d 0,5, rata-rata 0,12 — bukan data kotor, tapi temuan bisnis yang perlu dicermati lebih lanjut.

## Output
Tabel `orders_clean` — versi siap pakai dari data transaksi, menjadi sumber tunggal untuk seluruh analisis KPI dan pemodelan data berikutnya.

## Kesimpulan
Data Preparation (Collection, Profiling, Cleaning, Validation) selesai tanpa kehilangan data dan tanpa memerlukan proses cleaning tambahan yang kompleks. Satu sinyal bisnis penting ditemukan pada tahap ini (55% order berstatus "Late delivery") yang menjadi titik awal investigasi lebih lanjut — namun kemudian, pada tahap KPI Design/EDA, terbukti sebagai artifak data, bukan sinyal operasional riil.
