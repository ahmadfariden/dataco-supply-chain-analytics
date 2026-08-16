# 1.1 Business Problem & KPI Design

## Tujuan
Mendefinisikan masalah bisnis yang ingin dijawab dan merancang KPI yang relevan, dipetakan ke kerangka Sheet 1-5 (Revenue, Distributor/Region, Inventory, Product, Financial) yang telah didesain sebelumnya.

## Input
- Kerangka KPI Sheet 1-5 (Executive Overview, Revenue & Distributor Performance, Product & SKU Performance, Financial & Risk Management)
- Dataset DataCo Smart Supply Chain (114.187 baris transaksi, Jan 2015 - Jan 2018)

## Proses Analisis
1. Memetakan setiap KPI di kerangka Sheet 1-5 ke kolom yang tersedia di dataset DataCo.
2. Mengidentifikasi KPI yang bisa dihitung langsung, yang butuh proxy, dan yang tidak bisa dihitung sama sekali karena data tidak tersedia.
3. Menyusun pertanyaan bisnis inti yang akan dijawab oleh analisis.

## Temuan
- Dari 16 KPI di Sheet 1, hanya sebagian yang punya data pendukung langsung di DataCo (Revenue, Region, Product Category, OTIF proxy).
- **Tidak tersedia sama sekali**: Forecast Accuracy, Stock Availability (gudang), Dead Stock % (definisi asli), Distributor Satisfaction (indeks komposit), Bad Debt Risk/DSO, data Supplier.
- Konsep "Distributor" di kerangka asli harus diterjemahkan sebagai **Customer** di dataset ini — karena DataCo tidak punya struktur distributor B2B, hanya data transaksi customer individual.
- Pertanyaan bisnis inti yang bisa dijawab: (1) Bagaimana tren revenue dari waktu ke waktu? (2) Region/kategori mana penyumbang revenue terbesar? (3) Produk mana yang tumbuh/menurun? (4) Apakah ada risiko konsentrasi revenue?

## Output
Daftar KPI final yang layak dihitung dari DataCo, dikelompokkan per layer: Revenue, Region, Customer, Product, Financial. KPI delivery/OTIF ditandai perlu validasi lebih lanjut (lihat Business Rules).

## Kesimpulan
Business problem yang realistis untuk dijawab dari dataset ini adalah seputar **Revenue performance, Region & Category contribution, dan Product growth** — bukan operational excellence (forecast, inventory, distributor satisfaction) karena data pendukungnya tidak tersedia. KPI Design ini menjadi dasar bagi Business Rules (1.2) yang menetapkan validitas tiap metrik setelah investigasi data.
