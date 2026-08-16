# 2.1 Data Collection & Profiling

## Tujuan
Mengidentifikasi sumber data yang tersedia, memuatnya ke DuckDB, dan mengenali karakteristik dasarnya (kelengkapan, keunikan, duplikasi, format) sebelum masuk ke tahap cleaning.

## Input
- Folder lokal berisi dataset DataCo Smart Supply Chain (Kaggle)
- File: `DataCoSupplyChainDataset.csv` (data utama), `DescriptionDataCoSupplyChain.csv` (kamus data), `tokenized_access_logs.csv` (di-skip, tidak relevan)

## Proses Analisis
1. Identifikasi seluruh file dalam folder sumber menggunakan `glob()`.
2. Load CSV ke DuckDB sebagai tabel `orders` (all_varchar, ignore_errors=true) mengingat isu encoding pada file sumber.
3. Cek jumlah baris, struktur kolom, null di kolom kunci, jumlah nilai unik per kolom kategori.
4. Identifikasi format tanggal asli dan validasi parsing menggunakan `TRY_STRPTIME`.
5. Cek duplikasi pada kombinasi Order Id + Order Item Id.

## Temuan
- **114.187 baris, 53 kolom** berhasil dimuat, seluruhnya bertipe VARCHAR di tahap awal.
- **0 null** di kolom kunci (Order Id, Customer Id, Sales, Region, Product, Order Date).
- Kategori bersih dan masuk akal: 5 Market, 22 Region, 115 Country, 3 Customer Segment, 9 Order Status, 4 Delivery Status, 4 Shipping Mode, 50 Category.
- 18.296 customer unik, 42.386 order unik (rata-rata ~2,7 item per order).
- Format tanggal asli `M/D/YYYY H:MM` (tanpa leading zero) — gagal di-cast otomatis, tapi berhasil 100% dengan `STRPTIME` format spesifik. Rentang tanggal: 2015-01-01 s/d 2018-01-31.
- **0 duplikat** pada kombinasi Order Id + Order Item Id.

## Output
Tabel `orders` (mentah, tervalidasi struktur) dan `data_dictionary` — siap menjadi basis untuk Data Cleaning.

## Kesimpulan
Dataset ini secara struktural sangat bersih — tidak ada null di kolom kunci, tidak ada duplikat, kategori masuk akal. Satu-satunya isu adalah format tanggal non-standar yang sudah ditemukan solusinya, sehingga tidak diperlukan proses cleaning tambahan yang signifikan pada tahap berikutnya.
