# 3.1 Star Schema

## Tujuan
Merancang dan mengimplementasikan model Star Schema (fact table + dimension tables) dari `orders_clean`, sebagai struktur data yang optimal untuk koneksi ke Power BI.

## Input
Tabel `orders_clean` (114.187 baris, hasil Data Preparation)

## Proses Analisis
1. Merancang skema: 1 fact table (`fact_orders`, grain: 1 baris = 1 order item) dan 5 dimension table (`dim_customer`, `dim_product`, `dim_region`, `dim_date`, `dim_shipping`).
2. Melakukan review desain awal dan memperbaiki 3 gap: (a) `order_status` yang sempat hilang dari model — ditambahkan sebagai degenerate dimension; (b) `delivery_status` dan `late_delivery_risk` yang disebut "retained for reference" di catatan tapi tidak ada di tabel manapun — ditambahkan langsung ke fact table; (c) `product_price` dan `order_item_total` yang hilang tanpa penjelasan — didokumentasikan eksplisit sebagai keputusan sadar karena redundan terhadap `sales`.
3. Memvalidasi diagram ERD (Mermaid) untuk memastikan seluruh relasi dan tipe data konsisten.

## Temuan
- Skema final terdiri dari `fact_orders` (dengan `fact_order_key` sebagai surrogate PK) dan 5 dimension table, seluruhnya terhubung via foreign key one-to-many yang valid.
- Business/natural key (order_id, customer_id, product_id) disimpan sebagai VARCHAR, bukan INTEGER — praktik standar data warehousing agar ID tidak diperlakukan sebagai nilai yang bisa dihitung secara matematis.
- `dim_date` hanya merepresentasikan `order_date` — tidak dibuat tabel tanggal kedua untuk `shipping_date` karena informasi timing sudah terwakili oleh `shipping_days_actual`/`scheduled`.

## Output
Dokumen `star_schema_final.md` berisi struktur lengkap fact & dimension table, relationship, dan design notes yang menjelaskan setiap keputusan pemodelan beserta alasannya.

## Kesimpulan
Star Schema berhasil dirancang dengan mempertimbangkan temuan data quality dari tahap sebelumnya — field yang terbukti tidak valid (delivery, discount) tetap disimpan di model untuk transparansi, bukan dihapus, agar siapa pun yang mengakses model dapat melihat datanya sambil diarahkan ke dokumentasi validitas (`data_quality_flags`).
