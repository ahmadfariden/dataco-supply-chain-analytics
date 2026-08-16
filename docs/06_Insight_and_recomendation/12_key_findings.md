# 6.1 Key Findings

## Tujuan
Merangkum seluruh temuan signifikan sepanjang project — baik insight bisnis yang valid maupun temuan data quality — sebagai ringkasan eksekutif sebelum masuk ke rekomendasi aksi.

## Input
Seluruh hasil analisis dari tahap Business Understanding, Analytics, dan Power BI Dashboard.

## Proses Analisis
Mengonsolidasikan temuan dari `data_quality_flags`, insight card dashboard, dan hasil investigasi statistik (EDA) menjadi satu ringkasan terstruktur.

## Temuan

### Insight Bisnis (Valid, Actionable)
1. **Revenue Decline 2016→2017 (-38%)** — signal bisnis nyata, konsisten di hampir semua produk top. Root cause belum dapat dipastikan karena dataset tidak memiliki data marketing/kompetitor.
2. **Customer Base Highly Dispersed** — Top 10 customer hanya 0,28% dari total revenue; risiko konsentrasi lebih bermakna dianalisis di level Region/Category.
3. **High Margin ≠ High Impact** — kategori dengan margin % tertinggi bukan kategori dengan kontribusi profit absolut terbesar; keputusan prioritisasi kategori perlu menggabungkan kedua metrik.

### Temuan Data Quality (Membatasi Interpretasi)
4. **DQ-01 (High)**: Delivery performance (`shipping_days_actual`, `delivery_status`, `late_delivery_risk`) terbukti deterministik dari `shipping_mode`, bukan data operasional riil — tidak dapat dipakai untuk analisis OTIF.
5. **DQ-02 (Medium)**: Diskon tidak memiliki elastisitas terukur terhadap volume maupun profit (korelasi ≈ 0) — tidak dapat dipakai untuk mengukur efektivitas promosi.
6. **DQ-03 (High)**: customer_id periode Nov 2017-Jan 2018 tidak overlap dengan histori sebelumnya — churn/retention analysis tidak reliable untuk periode ini.
7. **DQ-05 (Low)**: Data Januari 2018 tidak lengkap — dikecualikan dari seluruh perbandingan Year-over-Year.
8. **DQ-06 (Medium)**: ~18-19% order rugi, namun rate ini merata di semua dimensi — pola random bawaan dataset, bukan masalah bisnis yang bisa ditelusuri ke penyebab spesifik.

## Output
Ringkasan 8 temuan utama (3 insight bisnis + 5 temuan data quality prioritas), menjadi dasar penyusunan Business Action Plan.

## Kesimpulan
Kekuatan utama project ini terletak pada kemampuan membedakan sinyal bisnis nyata dari artifak/noise data — dari 6 area yang diinvestigasi mendalam (delivery, discount, loss rate, customer concentration, customer integrity, data completeness), hanya 1 (Revenue Decline 2016-2017) yang terkonfirmasi sebagai sinyal bisnis yang memerlukan tindak lanjut investigasi eksternal. Temuan ini menjadi dasar rekomendasi aksi yang realistis dan berbasis bukti pada tahap berikutnya.
