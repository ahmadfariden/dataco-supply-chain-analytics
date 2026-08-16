# 4.1 Exploratory Data Analysis (EDA)

## Tujuan
Menggali statistik deskriptif, deteksi outlier, dan korelasi antar variabel numerik untuk memahami karakteristik data secara kuantitatif — melengkapi temuan kualitatif dari tahap KPI Design dengan bukti statistik.

## Input
Tabel `orders_clean` / `fact_orders`

## Proses Analisis
1. Menghitung statistik deskriptif (min, Q1, median, mean, Q3, max, stddev) untuk `sales`, `order_qty`, `benefit_per_order`, `product_price`.
2. Deteksi outlier pada `sales` menggunakan metode IQR.
3. Menghitung korelasi Pearson antar variabel kunci: qty-sales, price-sales, discount-qty, discount-profit, sales-profit, scheduled-actual shipping days.
4. Menganalisis distribusi jumlah item per order dan variabilitas revenue antar kategori (coefficient of variation).

## Temuan
- `sales`: median 199,92 vs mean 203,78 — distribusi relatif simetris.
- `product_price`: mean (141,99) jauh di atas median (59,99) — right-skewed, dipengaruhi segelintir produk mahal.
- `benefit_per_order` memiliki outlier ekstrem (min -4.274,98) yang layak diselidiki terpisah.
- Outlier `sales` (metode IQR) hanya **0,28%** dari total data — dataset tergolong bersih dari outlier ekstrem.
- **Korelasi price-sales = 0,80** (kuat, masuk akal).
- **Korelasi discount-qty = -0,002 dan discount-profit = -0,02** — praktis nol, menjadi bukti matematis final bahwa diskon tidak memiliki elastisitas terhadap volume maupun profitabilitas.
- **Korelasi scheduled-actual shipping days = 0,52** (moderat, bukan 1,0 sempurna) — konsisten dengan pola deterministik yang berbeda per shipping_mode, bukan hubungan linear seragam.
- Distribusi item per order relatif rata (~7.200 di tiap kategori 2-5 item) — sedikit "terlalu rapi" dibanding pola order riil yang biasanya skewed.

## Output
Bukti statistik kuantitatif yang mengonfirmasi temuan investigasi kualitatif sebelumnya (discount dan delivery sebagai artifak data), didokumentasikan sebagai dasar Business Rules.

## Kesimpulan
EDA memberikan validasi matematis, bukan sekadar observasi manual, terhadap dua temuan noise utama dalam dataset ini. Hasil ini memperkuat kredibilitas keputusan untuk mengecualikan `discount_rate` dan field delivery dari KPI bisnis di tahap-tahap selanjutnya.
