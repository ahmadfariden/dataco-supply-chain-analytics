# 4.2 Sales & Product Analysis

## Tujuan
Menganalisis performa penjualan dan produk — tren revenue, kontribusi kategori, pertumbuhan produk, dan hubungan margin terhadap volume — sebagai dasar Page 1 & Page 3 dashboard Power BI.

## Input
`fact_orders`, `dim_product`, `dim_date`

## Proses Analisis
1. Menghitung tren revenue bulanan dan tahunan.
2. Menghitung kontribusi revenue per kategori dan produk (Top 10).
3. Membandingkan revenue 2016 vs 2017 per produk untuk mengukur growth (2015 & 2018 dikecualikan karena data tidak lengkap).
4. Menghitung profit margin % per kategori dan membandingkannya dengan kontribusi revenue absolut.

## Temuan
- **Total Revenue: 23,27 juta**, dengan tren naik dari 2015 ke puncak di pertengahan 2016, lalu menurun bertahap hingga akhir data (Jan 2018 — data tidak lengkap, lihat catatan di bawah).
- **Fishing** adalah kategori dengan revenue terbesar (18,67% dari total), diikuti Cleats dan Camping & Hiking.
- **Revenue Decline 2016→2017**: turun ~38% (9,84 juta → 6,14 juta), konsisten di hampir semua produk top (-50% hingga -80% per produk) — terkonfirmasi sebagai **sinyal bisnis nyata**, bukan noise, karena polanya proporsional dan tersebar luas.
- **High Margin ≠ High Impact**: kategori dengan margin % tertinggi (Lacrosse, Soccer, Golf Gloves) bukan kategori dengan revenue/profit absolut terbesar — kategori bervolume tinggi seperti Fishing memiliki margin moderat (~12%) namun kontribusi profit absolut jauh lebih besar karena volume transaksi.
- Data Januari 2018 tidak lengkap (hanya 1 bulan) — menyebabkan penurunan tajam yang tampak di ujung grafik tren, namun ini adalah artifak kelengkapan data, bukan penurunan bisnis riil.

## Output
Insight terdokumentasi: (1) Revenue Decline 2016-2017 sebagai temuan prioritas untuk investigasi lanjutan, (2) High Margin ≠ High Impact sebagai panduan prioritisasi kategori, (3) caveat data Jan 2018.

## Kesimpulan
Analisis produk & penjualan menghasilkan dua insight strategis: penurunan revenue 2016-2017 yang memerlukan investigasi eksternal (marketing, kompetitor), dan pentingnya menggabungkan margin % dengan volume/profit absolut saat memprioritaskan kategori — bukan mengandalkan margin % semata.
