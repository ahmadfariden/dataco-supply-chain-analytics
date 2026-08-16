# 4.3 Region & Customer Analysis

> **Catatan penamaan**: bagian ini semula bernama "Branch & Distributor Analysis" pada draft struktur project. Nama diganti karena dataset DataCo tidak memiliki konsep Branch (cabang fisik) — yang tersedia hanya data geografis (Market/Region) dan Customer individual sebagai proxy Distributor.

## Tujuan
Menganalisis performa berdasarkan region geografis dan pola aktivitas customer — kontribusi revenue, distribusi segment, dan indikasi risiko konsentrasi — sebagai dasar Page 2 dashboard Power BI.

## Input
`fact_orders`, `dim_region`, `dim_customer`

## Proses Analisis
1. Menghitung revenue dan order volume per region/market.
2. Menganalisis distribusi customer per segment (Consumer, Corporate, Home Office).
3. Menghitung Revenue Concentration (kontribusi Top 10 customer terhadap total revenue).
4. Menganalisis recency (proxy churn) dan pola New vs Repeat Customer per bulan.

## Temuan
- **Western Europe** adalah region dengan revenue terbesar (15,85% dari total), diikuti Oceania dan Northern Europe — distribusi antar 22 region relatif merata, tidak ada dominasi ekstrem.
- **Consumer** adalah segment dominan (51,85% revenue, 51,79% jumlah customer), diikuti Corporate dan Home Office.
- **Customer Base Sangat Tersebar**: Top 10 customer hanya menyumbang **0,28%** dari total revenue (~65K dari 23,27 juta) — jauh dari pola konsentrasi khas distributor B2B. Rata-rata order per customer hanya 2,32 kali, mengindikasikan hubungan transaksional, bukan loyalitas jangka panjang.
- **Anomali struktural**: pada periode November 2017 - Januari 2018, 100% order tercatat berasal dari "customer baru" (0 repeat customer) — pola yang tidak masuk akal secara bisnis, mengindikasikan customer_id pada periode tersebut tidak overlap dengan histori sebelumnya.

## Output
Insight terdokumentasi: "Customer Base is Highly Dispersed" — rekomendasi agar analisis Concentration Risk dialihkan ke level Region atau Category, bukan Customer individual.

## Kesimpulan
Konsep "Distributor Concentration Risk" dan "Churn Rate" dari kerangka Sheet 2 tidak dapat diterapkan secara bermakna pada dataset ini di level Customer — dataset lebih cocok dianalisis melalui Region dan Category untuk kebutuhan risk management. Periode Nov 2017 - Jan 2018 dikecualikan dari analisis retention/churn karena cacat data struktural.
