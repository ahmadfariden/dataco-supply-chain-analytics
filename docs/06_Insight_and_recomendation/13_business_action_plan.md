# 6.2 Business Action Plan

## Tujuan
Menyusun rencana aksi konkret berdasarkan Key Findings, dikelompokkan berdasarkan prioritas dan pihak yang bertanggung jawab.

## Input
Dokumen Key Findings (6.1)

## Proses Analisis
Memetakan setiap temuan menjadi rekomendasi aksi yang spesifik, dapat dieksekusi, dan mempertimbangkan keterbatasan data yang telah teridentifikasi.

## Temuan
Rencana aksi dikelompokkan menjadi 3 kategori:

**A. Investigasi Lanjutan (Prioritas Tinggi)**
- Investigasi penyebab Revenue Decline 2016-2017 menggunakan data eksternal (marketing spend, kondisi kompetitor) yang tidak tersedia di dataset ini.
- Konfirmasi ke tim Sales/Product terkait perubahan strategi bisnis pada periode tersebut.

**B. Perbaikan Kualitas Data (Prioritas Tinggi-Sedang)**
- Audit sumber data delivery/OTIF — data `shipping_days_actual` saat ini tidak dapat dipercaya untuk pengambilan keputusan operasional.
- Audit sumber data customer_id pada periode Nov 2017-Jan 2018 untuk memastikan tidak ada gangguan sistem pencatatan.
- Jika data promosi/diskon ingin digunakan untuk pengukuran efektivitas, diperlukan data promosi yang tercatat terpisah dari harga transaksi (bukan hanya kolom discount_rate).

**C. Perubahan Pendekatan Analisis (Prioritas Sedang-Rendah)**
- Terapkan analisis Concentration Risk di level Region/Category, bukan Customer individual.
- Gabungkan margin % dengan profit absolut saat memprioritaskan kategori untuk investasi/ekspansi.
- Kecualikan tahun 2018 dari seluruh pelaporan Year-over-Year hingga data lengkap tersedia.

## Output
Rencana aksi terstruktur yang siap ditindaklanjuti oleh tim terkait (Sales, Data Engineering, Business Analyst), dengan pembagian prioritas yang jelas.

## Kesimpulan
Rencana aksi ini secara sengaja tidak memaksakan rekomendasi bisnis dari data yang terbukti tidak valid (delivery, discount, loss rate) — sebaliknya, sebagian besar rekomendasi berfokus pada perbaikan kualitas data dan investigasi lanjutan menggunakan sumber data eksternal. Pendekatan ini mencerminkan prinsip kerja yang jujur secara analitis: mengakui keterbatasan data lebih baik daripada memaksakan insight yang tidak berdasar.
