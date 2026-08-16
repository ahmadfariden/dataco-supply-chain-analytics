-- ============================================================
-- DATA DICTIONARY
-- Tujuan: Dokumentasikan definisi tiap kolom di orders_clean
--         beserta status validitasnya (ref Step 14)
-- ============================================================

-- Tarik deskripsi asli dari Kaggle (kamus data mentah)
SELECT * FROM data_dictionary;

-- Referensi struktur kolom orders_clean
DESCRIBE orders_clean;

-- ----- DATA DICTIONARY LENGKAP: orders_clean -----
-- order_id                 INTEGER   ID unik order (1 order bisa berisi banyak item)          VALID
-- order_item_id             INTEGER   ID unik per item dalam order (grain tabel ini)            VALID
-- customer_id               INTEGER   ID pelanggan (proxy Distributor/Channel)                  VALID
-- customer_segment          VARCHAR   Consumer / Corporate / Home Office                        VALID
-- customer_city/state/country VARCHAR Lokasi pelanggan                                          VALID
-- market                    VARCHAR   Region agregat tertinggi (5 nilai)                        VALID
-- order_region               VARCHAR   Region order, level lebih detail dari market (22 nilai)   VALID
-- order_country/state/city   VARCHAR   Lokasi pengiriman order                                   VALID
-- product_id                 INTEGER   ID produk                                                 VALID
-- product_name                VARCHAR   Nama produk                                               VALID
-- category_name               VARCHAR   Kategori produk (50 kategori)                             VALID
-- department_name              VARCHAR   Departemen/divisi produk                                  VALID
-- sales                        DOUBLE    Revenue dari item ini                                     VALID
-- order_qty                    INTEGER   Jumlah unit yang dipesan                                  VALID
-- discount_amount               DOUBLE    Nominal diskon                                            TIDAK VALID (elastisitas nol)
-- discount_rate                 DOUBLE    Persentase diskon (0-1)                                   TIDAK VALID (elastisitas nol)
-- product_price                  DOUBLE    Harga satuan produk                                       VALID
-- order_item_total                DOUBLE    Total nilai item (qty x price - discount)                VALID
-- profit_ratio                     DOUBLE    Rasio profit per order (-2.75 s/d 0.5)                    VALID
-- profit_per_order                  DOUBLE    Profit nominal per order                                  VALID
-- benefit_per_order                  DOUBLE    Sama seperti profit_per_order                              VALID
-- order_status                        VARCHAR   9 status (COMPLETE, CANCELED, PENDING, dst)               VALID
-- delivery_status                      VARCHAR   4 status pengiriman                                       TIDAK VALID (deterministik)
-- late_delivery_risk                    INTEGER   Binary 0/1, turunan dari delivery_status                  TIDAK VALID (deterministik)
-- shipping_days_actual                   INTEGER   Hari pengiriman aktual                                     TIDAK VALID (= scheduled x 2 atau x1, 0 variasi)
-- shipping_days_scheduled                 INTEGER   Hari pengiriman yang dijanjikan (SLA)                       VALID (sbg input)
-- shipping_mode                            VARCHAR   Same Day / First Class / Second Class / Standard Class      VALID
-- order_date                                TIMESTAMP Tanggal order dibuat (2015-01-01 s/d 2018-01-31)             VALID (2018 caveat)
-- shipping_date                              TIMESTAMP Tanggal barang dikirim                                       VALID

-- ----- GAP STRUKTURAL: kolom yang TIDAK ADA di dataset ini -----
-- Forecast Accuracy, Stock Availability (gudang), Dead Stock % (definisi asli),
-- Distributor Satisfaction (indeks komposit), Bad Debt Risk / DSO, Supplier data

-- Temuan & Kesimpulan:
-- Data dictionary ini menjadi acuan tunggal untuk semua step analisis selanjutnya
-- (Step 17 dst). Kolom bertanda TIDAK VALID tetap boleh dipakai untuk latihan
-- teknik SQL, tapi tidak boleh dijadikan dasar insight/klaim bisnis.
