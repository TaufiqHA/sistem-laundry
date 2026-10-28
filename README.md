# Sistem Manajemen Laundry

Aplikasi Android untuk pemilik laundry kecil: catat order, cetak nota dan label kantong ber-QR, pindai label untuk memajukan status, pantau piutang, dan buat laporan. Semua data tersimpan di perangkat, tanpa server dan tanpa langganan.

## Status

Fase 1–12 selesai. Fase 13 baru sebagian: WhatsApp, nota PDF, serta kategori/ekspres sudah ada; lisensi offline, poin loyalitas, ubah status massal, dan keygen penjual belum. Cetak dan scan label fisik masih menunggu printer. Lihat [Urutan Pengembangan](Urutan%20Pengembangan.md).

## Menjalankan

```bash
flutter pub get
make run          # debug di perangkat/emulator
make check        # format + analyze + test
make build        # APK release
```

Butuh Flutter 3.47+ dan Android SDK dengan `minSdk 26`.

## Dokumen

| Dokumen | Isi |
| --- | --- |
| [PRD](PRD%20Aplikasi%20Manajemen%20Laundry%20(Offline-First).md) | Kebutuhan produk, 37 FR, aturan bisnis |
| [Urutan Pengembangan](Urutan%20Pengembangan.md) | Urutan pengerjaan per fase dan gerbang uji |
| [Arsitektur](ARCHITECTURE.md) | Keputusan teknis, struktur folder, konvensi |

## Struktur singkat

```text
lib/
  core/      database, tema, router, util, log
  features/  order, customer, service, report, backup, printer, scan, license
test/        unit dan widget test
```

## Prinsip

- Offline penuh, tanpa akun dan tanpa server.
- Uang disimpan sebagai integer rupiah; qty sebagai integer 1/1000 satuan.
- Perubahan status lewat satu jalur domain, baik manual maupun hasil scan.
