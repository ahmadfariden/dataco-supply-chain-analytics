# Page 4 — Data Quality Notes: Panduan Build Lengkap

## Tujuan Halaman
Beda dari 3 page sebelumnya, page ini **tidak ada card/chart interaktif** — isinya murni dokumentasi transparansi soal batasan data, biar siapa pun yang review dashboard ini tau persis apa yang boleh dan tidak boleh dipercaya.

---

## 📋 Tabel (1 buah) — Satu-satunya Visual di Halaman Ini

### data_quality_flags
- **Jenis visual**: Table
- **Judul**: "Data Quality Findings"
- **Kolom** (urutan disarankan):
  - `data_quality_flags[finding_id]`
  - `data_quality_flags[category]`
  - `data_quality_flags[issue_description]`
  - `data_quality_flags[severity]`
  - `data_quality_flags[business_impact]`
  - `data_quality_flags[recommendation]`
- **Sumber**: `data_quality_flags` (berdiri sendiri, tidak ada relasi ke tabel lain)

### Cara Bikin
1. Klik area kosong di canvas
2. **Insert → Table**
3. Drag keenam kolom itu urut sesuai daftar di atas dari panel Fields

---

## 🎨 Conditional Formatting (Inti Halaman Ini)

### Kolom `severity` → Traffic Light

**Cara paling gampang** — pakai **Icon** conditional formatting:
1. Klik kolom `severity` di visual tabel → ikon **petir kecil** (Conditional formatting) → **Icons**
2. **Format style**: pilih **Rules**
3. Bikin 3 rule manual:
   - Kalau `severity` = "High" → icon 🔴 (merah)
   - Kalau `severity` = "Medium" → icon 🟡 (kuning)
   - Kalau `severity` = "Low" → icon 🟢 (hijau)

> Power BI conditional formatting icon biasanya berbasis angka, bukan teks langsung. Kalau rules berbasis teks tidak tersedia di versi lo, cara alternatif: tambah kolom bantu di Power Query yang convert severity jadi angka (High=3, Medium=2, Low=1), baru pakai icon set built-in "Traffic Light" berdasarkan kolom angka itu (kolom angkanya di-hide dari tampilan).

### Kolom `business_impact` → Color Scale

⚠️ **Catatan**: kolom `business_impact` isinya **teks panjang** (deskripsi kalimat), bukan angka — color scale otomatis **tidak akan jalan** di kolom ini (color scale butuh data numerik).

**Solusi**: skip conditional formatting di `business_impact`, cukup andalkan formatting di kolom `severity` saja sebagai indikator visual utama.

---

## 📐 Layout yang Disarankan

```
┌──────────────────────────────────────────────────┐
│  Data Quality Notes — DataCo Supply Chain         │  ← judul halaman
├──────────────────────────────────────────────────┤
│  Subtitle: "6 findings documented — review before │
│  using specific fields for business decisions"     │
├──────────────────────────────────────────────────┤
│                                                      │
│   [Tabel data_quality_flags — lebar penuh]         │
│   dengan kolom severity ber-icon 🔴🟡🟢            │
│                                                      │
└──────────────────────────────────────────────────┘
```

Judul halaman: **"Data Quality Notes — DataCo Supply Chain Analytics"**

Subtitle/text box tambahan di bawah judul:
> *"This page documents known data limitations identified during analysis. Fields marked High severity should not be used for business KPIs without the noted caveats."*

---

## Kenapa Halaman Ini Penting

Ini yang bikin dashboard beda dari kebanyakan portofolio orang lain — kebanyakan orang cuma nunjukin chart yang "kelihatan bagus", tapi jarang yang transparan soal keterbatasan datanya sendiri. Halaman ini menunjukkan kemampuan *root cause investigation*, bukan cuma bisa bikin visual.
