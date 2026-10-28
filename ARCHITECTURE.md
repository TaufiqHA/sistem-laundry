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
- **Enum** disimpan sebagai index (`intEnum`). Jangan mengubah urutan nilai enum setelah ada data; tambah nilai baru hanya di akhir.
- **Soft delete** lewat kolom `dihapus_pada` untuk order dan pembayaran; layanan dinonaktifkan lewat `aktif`, tidak dihapus.
- **Transaksi** wajib untuk perubahan yang menyentuh lebih dari satu tabel (order + item + riwayat status, pembayaran + status).
- **Piutang** tidak disimpan sebagai kolom, selalu dihitung `total − pembayaran aktif`.
- **Snapshot** nama layanan, harga satuan, dan total disalin ke order agar perubahan harga tidak mengubah riwayat.
- **Nomor nota** memakai counter per tanggal lokal (`{tanggal}` = `yyyyMMdd`, `{urut}` = tiga digit) dan dibuat di transaksi yang sama dengan order, sehingga dua order berturut-turut tidak mungkin mendapat nomor sama.
- **Subtotal item** = `(qtyMilli × hargaSatuan + 500) ~/ 1000`, dibulatkan ke rupiah terdekat di satu tempat.
- **Telepon pelanggan** disimpan ternormalisasi `62...`; tampilan memakai awalan `0` lewat `PhoneNumber.display`.
- **Pembayaran** tidak boleh melebihi sisa piutang, tidak boleh nol/negatif, dan tidak boleh dicatat pada order yang dibatalkan. Penghapusan pembayaran bersifat soft delete sehingga piutang otomatis naik kembali.
- **Status** hanya maju satu tahap lewat `advanceStatus`; urungkan menulis baris riwayat baru dengan sumber `urungkan`, bukan menghapus riwayat.
- **QR label** berisi `LDR1:<nomor_nota>:<token>`; token tidak berubah saat cetak ulang.

## Cetak

- `EscPosBuilder` menyusun byte ESC/POS tanpa menyentuh Bluetooth, sehingga template bisa diuji tanpa printer. `PrinterService` hanya mengirim byte.
- Nota memuat identitas usaha, item, total, dibayar, dan sisa; label kantong **tidak memuat harga**.
- QR label memakai error correction M, ukuran modul mengikuti `58x40` atau `58x30`.
- `permission_handler` dipatok ke 12.x karena versi 13 menuntut `compileSdk 37`, sedangkan proyek memakai 36.
- Izin Android: `BLUETOOTH_CONNECT`, `BLUETOOTH_SCAN` (Android 12+), dan izin Bluetooth lama untuk Android ≤ 11.

## Pemindaian QR

- Payload label: `LDR1:<nomor_nota>:<token>`. Prefix lain dianggap QR asing dan tidak diproses.
- Lookup memakai token, bukan nomor nota, karena token acak tidak bisa ditebak. Nomor nota hanya untuk fallback manual.
- Label yang sama diabaikan selama 3 detik agar satu label tidak memajukan dua tahap.
- Hasil lookup dibedakan menjadi siap, sudah diambil, dibatalkan, tidak dikenal, dan QR tidak valid.
- Perubahan status dari scan memakai `advanceStatus` yang sama dengan jalur manual, dengan sumber `scan`.
- Scan dibuka sebagai layar penuh dari item navigasi, bukan tab, supaya kamera tidak tetap hidup saat pengguna pindah tab.

## Beranda

- Angka hari ini dihitung dari tanggal lokal: jumlah order memakai `tanggal_masuk`, pemasukan memakai tanggal pembayaran, piutang baru dari order hari ini.
- "Siap diambil" = status Selesai; "menumpuk" = belum Diambil dan `tanggal_masuk` lebih lama dari batas hari di pengaturan.
- Setiap perubahan order memanggil `invalidateOrderViews` agar daftar, detail, dan beranda ikut segar tanpa perlu buka-tutup aplikasi.
- Indikator backup memakai `last_backup_at` dan ditampilkan di Pengaturan → Backup & restore, bukan di beranda.

## Laporan

- **Pemasukan** dihitung dari pembayaran pada periode (uang masuk), bukan total order.
- **Jumlah order** dihitung dari `tanggal_masuk` pada periode dan mengabaikan order yang dibatalkan.
- **Layanan terlaris** dikelompokkan dari snapshot `order_items.nama_layanan`, diurutkan berdasarkan omzet; satuan diambil dari layanan asal untuk tampilan.
- **Laba** = pemasukan − pengeluaran. Pengeluaran belum punya kolom soft delete, jadi penghapusan bersifat permanen dengan konfirmasi.
- Grafik dan ekspor PDF/Excel (FR-24) tetap ditunda ke P2.

## Backup dan restore

- Format: ZIP berisi `laundry.sqlite` dan `meta.json` (format versi, skema, tanggal, jumlah order/pelanggan, SHA-256 database).
- Sebelum dibaca, WAL di-checkpoint agar file utama memuat data terbaru.
- Saat restore: file divalidasi (ZIP, metadata, skema tidak lebih baru, checksum), backup otomatis dibuat, database ditutup, file diganti, lalu aplikasi wajib ditutup dan dibuka lagi.
- Lima file backup terakhir disimpan di folder `backups`; file lama dihapus otomatis.
- Belum ada: enkripsi backup dan notifikasi pengingat terjadwal. Indikator umur backup di beranda sudah berjalan.
- Catatan: `last_backup_at` disimpan setelah arsip dibuat, jadi database hasil restore menunjukkan "belum pernah backup" sampai backup berikutnya dibuat.

## Keamanan

- PIN 6 angka, disimpan sebagai SHA-256 bergaram dengan 1.000 iterasi. PIN asli tidak pernah disimpan.
- Kunci aktif saat aplikasi dibuka dan saat kembali dari latar belakang setelah 5 menit.
- Layar kunci berupa overlay di atas aplikasi, jadi state navigasi tidak hilang saat membuka kunci.
- Salah PIN 5 kali memberi jeda 30 detik.
- Biometrik belum diimplementasikan; `local_auth` dan `FlutterFragmentActivity` akan ditambahkan saat fitur itu dikerjakan.

## Performa dan ukuran

| Metrik | Hasil |
| --- | --- |
| Cold start (release, Waydroid) | ±310 ms setelah peluncuran pertama |
| Peluncuran pertama setelah instal | ±3,4 detik (pemanasan dex) |
| APK arm64 | 29,6 MB (batas PRD 30 MB) |
| APK armeabi-v7a | 25,7 MB |
| APK x86_64 | 32,0 MB (khusus emulator) |

Kenaikan ukuran berasal dari `mobile_scanner` (ML Kit) dan `file_picker`. Arm64 masih di bawah batas, tapi tinggal 0,4 MB; fitur berikutnya perlu memantau ini atau memakai ML Kit tanpa bundel.

## WhatsApp, PDF, dan kategori

- Pesan WhatsApp disusun sebagai teks murni di `WhatsAppMessage`, lalu diubah menjadi tautan `wa.me` dengan nomor `62`. Kalau WhatsApp tidak tersedia, pesan disalin ke papan klip.
- Nota PDF dibuat dengan paket `pdf` (A5) lalu dibagikan lewat share sheet; tidak bergantung pada printer.
- Kategori layanan sekarang diisi bebas (dengan saran cepat). "Ekspres" diperlakukan sebagai layanan terpisah dengan harga sendiri, bukan kolom tambahan di order.

## Database

| Item | Nilai |
| --- | --- |
| File | `app_flutter/laundry.sqlite` (dokumen aplikasi) |
| Mode | WAL, `PRAGMA foreign_keys = ON` setiap koneksi |
| Versi skema | `1` |
| Pembuatan | `main()` membuka database sebelum layar pertama agar migrasi selesai lebih dulu |
| Kode generate | `lib/core/database/app_database.g.dart` di-commit; jalankan `make gen` setelah mengubah tabel |
| Pengisi data contoh | `DevSeeder` (khusus debug/test) |

Uji performa dengan `make perf`: 50.000 order di memori, seed ±3 detik, pencarian nota/telepon dan ringkasan harian 1-5 ms. Angka di perangkat nyata perlu diukur ulang di Fase 14.

Tipe enum dan `nowUtc` diimpor di `app_database.dart` karena file generate berstatus `part` dan hanya melihat import library induknya.

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

- Teks yang dipakai lintas layar ada di `lib/core/l10n/app_strings.dart`; teks khas satu fitur ditulis di file fitur itu. Saat multi-bahasa dikerjakan, keduanya menjadi titik migrasi ke ARB.
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
| Pembayaran langsung di form order baru | Uji MVP | Alur PRD 6.8 langkah 5; sementara pembayaran dicatat dari detail order |
