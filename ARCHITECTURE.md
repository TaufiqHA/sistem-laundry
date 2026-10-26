# Arsitektur

Dokumen ini mencatat keputusan teknis yang sudah dikunci. Setiap perubahan di sini harus disengaja, bukan kebetulan saat coding.

## Identitas aplikasi

| Item | Nilai | Catatan |
| --- | --- | --- |
| Nama paket Dart | `sistem_manajemen_laundry` | |
| `applicationId` Android | `id.laundry.sistem_manajemen_laundry` | Bisa diubah sebelum rilis pertama; setelah ada lisensi perangkat, jangan diubah |
| Nama tampilan | Laundry | `android:label` |
| `minSdk` | 26 (Android 8.0) | Sesuai PRD |
| `targetSdk` / `compileSdk` | Mengikuti Flutter SDK | |

## Stack

| Kebutuhan | Paket | Versi di pubspec |
| --- | --- | --- |
| Database | `drift` + `drift_flutter` | 2.35.x |
| State management | `flutter_riverpod` | 3.4.x, tanpa codegen |
| Navigasi | `go_router` | 18.x |
| Format tanggal/angka | `intl` | 0.20.x |
| Lokasi file | `path_provider` | 2.1.x |
| Lokalisasi bawaan | `flutter_localizations` | SDK |

Paket khusus fase lanjut (printer, kamera, PDF, notifikasi) sengaja belum ditambahkan supaya build tetap ringan sampai fiturnya dikerjakan.

## Aturan data

- **Uang** disimpan sebagai `int` rupiah. Tidak ada `double` untuk uang, termasuk di perhitungan diskon dan piutang.
- **Qty** disimpan sebagai `int` dalam satuan 1/1000 (2,5 kg = `2500`). Pembulatan hanya terjadi saat tampil, bukan saat simpan.
- **Waktu** disimpan UTC, ditampilkan dalam waktu lokal perangkat.
- **ID** memakai `int autoincrement`. Restore backup mengganti seluruh database, jadi ID tetap konsisten.
- **Soft delete** lewat kolom `dihapus_pada` untuk order dan pembayaran; layanan dinonaktifkan lewat `aktif`, tidak dihapus.
- **Transaksi** wajib untuk perubahan yang menyentuh lebih dari satu tabel (order + item + riwayat status, pembayaran + status).
- **Piutang** tidak disimpan sebagai kolom, selalu dihitung `total − pembayaran aktif`.
- **Snapshot** nama layanan, harga satuan, dan total disalin ke order agar perubahan harga tidak mengubah riwayat.

## Lapisan

```text
presentation  widget, layar, controller Riverpod
domain        aturan bisnis murni (status, uang, piutang), tanpa Flutter/DB
data          repository + DAO Drift
```

Aturan yang dijaga:

1. Widget tidak menyentuh `AppDatabase` langsung, selalu lewat repository.
2. Aturan status (maju satu tahap, undo, status terminal) ada di domain dan dipakai jalur manual maupun scan.
3. Repository mengembalikan model domain, bukan `DataClass` hasil generate Drift, kecuali untuk query laporan yang butuh agregasi.

## Struktur folder

```text
lib/
  core/            # database, tema, router, util, log, widget bersama
  features/
    order/         # nota, item, status, cetak
    customer/      # pelanggan, piutang
    service/       # layanan dan harga
    report/        # laporan harian/bulanan
    backup/        # ekspor dan impor
    printer/       # nota dan label Bluetooth
    scan/          # pemindai QR dan konfirmasi status
    license/       # aktivasi offline
  app.dart
  main.dart
```

Di dalam fitur, folder mengikuti kebutuhan: `presentation/`, `domain/`, `data/`.

## Konvensi

- Teks UI ada di `lib/core/l10n/app_strings.dart`. Saat multi-bahasa dikerjakan, file ini menjadi titik migrasi ke ARB.
- Setiap layar wajib punya keadaan kosong, memuat, dan gagal. `EmptyState` dipakai untuk keadaan kosong.
- Placeholder `ComingSoon` hanya boleh ada selama fase pengembangan dan dihapus saat fiturnya dikerjakan.
- Nama file `snake_case`, nama kelas `PascalCase`, satu widget utama per file.
- Format kode dan analisis dijalankan lewat `make check`.

## Keputusan yang masih terbuka

| Keputusan | Menunggu | Dampak |
| --- | --- | --- |
| Merek printer dan media label | Uji Fase 0 | Ukuran QR, template label |
| Harga jual dan saluran penjualan | Riset pasar | Fase 13, bukan kode inti |
| Status per kantong | Hasil uji 2-3 laundry | Skema `order_bags` |
| Nama usaha resmi untuk branding | Pemilik | `applicationId` sebelum rilis |
