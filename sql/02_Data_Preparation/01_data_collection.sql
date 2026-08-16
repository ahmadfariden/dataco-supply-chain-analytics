-- ============================================================
-- DATA COLLECTION
-- Tujuan: Identifikasi file mentah yang tersedia di folder project
-- ============================================================

-- Input: Folder C:\Users\ahmad farid\Downloads\FMCG\archive
-- List semua file di folder archive
SELECT * FROM glob('C:\Users\ahmad farid\Downloads\FMCG\archive\*');

-- Temuan:
-- - DataCoSupplyChainDataset.csv       -> data utama (transaksi)
-- - DescriptionDataCoSupplyChain.csv   -> kamus data (penjelasan kolom)
-- - tokenized_access_logs.csv          -> log akses web (di-skip, tidak relevan)
-- - Dataco.duckdb, duckdb.exe          -> file kerja, bukan sumber data
