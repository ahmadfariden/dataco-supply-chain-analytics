# 3.2 Data Transformation

## Tujuan
Mengeksekusi rancangan Star Schema menjadi struktur tabel nyata di database dan mem-populate datanya dari `orders_clean` menggunakan surrogate key.

## Input
Tabel `orders_clean` (114.187 baris) dan dokumen desain `star_schema_final.md`.

## Proses Analisis
1. `CREATE TABLE` untuk 5 dimension table, mengambil nilai unik dari `orders_clean` dan generate surrogate key menggunakan `ROW_NUMBER()`.
2. `dim_date` digenerate terpisah menggunakan `generate_series()` agar kalender lengkap dari tanggal minimum sampai maksimum, bukan hanya diambil dari tanggal yang ada transaksinya.
3. `CREATE TABLE fact_orders` dengan `LEFT JOIN` ke seluruh dimension table berdasarkan atribut natural, mengambil surrogate key masing-masing.
4. Validasi jumlah baris `fact_orders` harus tetap 114.187, dan seluruh foreign key harus berhasil ter-mapping (tidak ada NULL).

## Temuan
- `fact_orders` = **114.187 baris**, identik dengan `orders_clean` — tidak ada baris hilang atau terduplikasi akibat JOIN.
- **0 kegagalan mapping** di seluruh 5 foreign key.
- Jumlah baris dimension table sesuai ekspektasi: `dim_customer` (18.296), `dim_product` (118), `dim_region` (2.449), `dim_date` (1.127 hari kalender, sesuai rentang Jan 2015 - Jan 2018), `dim_shipping` (4).

## Output
6 tabel baru (`fact_orders` + 5 dim table) di database, siap dipakai untuk analisis lanjutan dan koneksi langsung ke Power BI.

## Kesimpulan
Implementasi Star Schema berhasil tanpa kehilangan data sedikit pun. Database sekarang memiliki 4 lapis struktur: Raw (`orders`), Clean (`orders_clean`), Star Schema (`fact_orders` + dimension tables), dan Mart (tabel agregat). Model ini menjadi fondasi untuk tahap Analytics dan Reporting berikutnya.
