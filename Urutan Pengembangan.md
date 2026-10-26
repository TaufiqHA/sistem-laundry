# Urutan Pengembangan — Sistem Manajemen Laundry (Offline-First)

Dokumen ini berisi urutan pengerjaan, bukan jadwal. Satu fase diselesaikan dan bisa dijalankan di HP sebelum fase berikutnya dimulai, kecuali ditandai boleh paralel. Rujukan `FR-xx` mengacu ke PRD.

**Status:** Fase 1 dan 2 selesai. Fase 0.3 (spike printer) menunggu perangkat fisik. Berikutnya Fase 3.

## Prinsip urutan

1. **Tiap fase berakhir dengan aplikasi yang jalan**, bukan kode setengah jadi. Tidak ada fase yang meninggalkan layar putih atau tombol mati.
2. **Uang dan status diuji otomatis sejak fase awal.** Dua area ini paling mahal kalau salah dan paling sulit ditemukan lewat klik manual.
3. **Risiko hardware divalidasi lebih dulu.** Printer dan QR dibuktikan sebelum desain label dikunci.
4. **Satu alur utuh lebih dulu, baru melebar.** Alur order → cetak label → scan → status harus selesai sebelum laporan dan grafik.
5. **Fitur P1 tidak disentuh sebelum MVP diuji** ke 2-3 laundry nyata.

## Peta ketergantungan

```text
Fase 0  Validasi printer
   |
Fase 1  Setup proyek
   |
Fase 2  Fondasi data (uang, DB, migrasi)
   |
Fase 3  Pengaturan + layanan --------+
   |                                  |
Fase 4  Pelanggan --------------------+---> bisa paralel
   |
Fase 5  Order & nota
   |
Fase 6  Pembayaran & piutang
   |
Fase 7  Status, cetak nota, label QR
   |
Fase 8  Scan QR  <-- vertical slice selesai di sini
   |
Fase 9  Beranda & daftar kerja
   |
Fase 10 Laporan -------+---> bisa paralel
Fase 11 Backup --------+
   |
Fase 12 Keamanan & poles
   |
Fase 13 Fitur 1.0 (WhatsApp, PDF, lisensi, poin)
   |
Fase 14 Uji perangkat, pilot, rilis
```

---

## Fase 0 — Keputusan teknis dan validasi printer

Dikerjakan sebelum menulis kode aplikasi. Tujuannya menghindari perubahan mahal di tengah jalan.

| Langkah | Isi | Selesai bila |
| --- | --- | --- |
| 0.1 | Kunci keputusan yang mahal diubah: `applicationId`, nama aplikasi, `minSdk 26`, `targetSdk` terbaru stabil, Riverpod tanpa codegen, Drift + `build_runner`, ID tabel `int autoincrement`, waktu disimpan UTC, uang `int` rupiah, qty `int` dalam satuan 1/1000 | Ditulis di `ARCHITECTURE.md` dan tidak ada yang masih tanda tanya |
| 0.2 | Siapkan perangkat uji: 1 HP kelas bawah (RAM 2-3 GB), 1 HP utama, printer thermal 58 mm, kertas label stiker 58×40 mm | Perangkat ada di meja, bukan "nanti dibeli" |
| 0.3 | **Spike printer**: proyek Flutter sekali pakai yang mencetak teks dan QR 30 mm ke printer asli | QR terbaca 20 dari 20 kali scan; waktu connect < 10 detik |
| 0.4 | Uji izin di Android 12+: `BLUETOOTH_CONNECT`, `BLUETOOTH_SCAN`, `CAMERA` | Ketiga izin muncul dan ditangani tanpa crash |
| 0.5 | Uji cetak label di dua media: stiker vs kertas struk | Terpilih satu media default untuk desain label |

**Gerbang 0:** kalau printer tidak bisa mencetak QR yang terbaca, ganti model printer sekarang. Jangan lanjut ke Fase 1 dengan asumsi.

**Keputusan yang diminta PRD dan perlu dijawab di sini:**

- Harga jual dan saluran penjualan (mempengaruhi Fase 13, bukan kode inti).
- Satu order biasanya berisi berapa kantong (mempengaruhi keputusan status per kantong, saat ini ditunda).
- Format nomor nota default.

---

## Fase 1 — Setup proyek

| Langkah | Isi | Selesai bila |
| --- | --- | --- |
| 1.1 | `flutter create` dengan `--org`, `--platforms=android`, `--project-name` yang benar; set `applicationId` dan `minSdk 26` | `flutter run` di HP uji menampilkan layar awal |
| 1.2 | Tambah dependensi inti: `drift`, `drift_flutter`, `flutter_riverpod`, `go_router`, `intl`, `path_provider`; dev: `drift_dev`, `build_runner`, `flutter_lints` | `flutter pub get` bersih, `dart run build_runner build` sukses |
| 1.3 | Struktur folder feature-first sesuai PRD, plus `core/` untuk database, tema, util, error | Folder kosong dengan `README` singkat per fitur |
| 1.4 | Tema Material 3, mode terang/gelap, ukuran teks dasar lebih besar, target sentuh minimal 48 dp | Toggle tema berfungsi tanpa restart |
| 1.5 | Lokalisasi `id_ID` lewat `flutter_localizations`; semua teks UI di satu tempat | Tidak ada teks Indonesia yang ditulis langsung di widget |
| 1.6 | `analysis_options.yaml` ketat (`strict-casts`, `avoid_print`, `prefer_const`), format otomatis, script `make check` = analyze + test | `make check` lulus di kondisi bersih |
| 1.7 | App shell: `go_router`, bottom navigation empat tab (Beranda, Order, Pelanggan, Laporan) + tombol Scan mengambang; Pengaturan dibuka dari ikon di Beranda; halaman masih placeholder | Semua tab terbuka, Scan dan Pengaturan kembali ke tab asal saat ditutup |
| 1.8 | Penanganan error global: `FlutterError.onError` + `PlatformDispatcher.onError`, log ke file lokal | Error buatan tercatat di file, aplikasi tidak mati diam-diam |
| 1.9 | Build release pertama, ukur ukuran APK | APK terpasang di HP uji, ukuran tercatat sebagai baseline (< 30 MB) |

**Gerbang 1:** aplikasi kosong tapi stabil, tema dan navigasi siap, build release berhasil.

---

## Fase 2 — Fondasi data

Fase terpenting. Semua tabel ditulis sekaligus di versi 1 supaya tidak ada migrasi dini.

| Langkah | Isi | Selesai bila |
| --- | --- | --- |
| 2.1 | Util uang: `formatRupiah(int)`, parser input `"25.000"` → `25000`, penolakan desimal dan nilai negatif | Unit test lulus untuk input kosong, ribuan, dan format salah |
| 2.2 | Util qty: simpan `int` dalam 1/1000 satuan (2,5 kg = `2500`), formatter tampilan `2,5 kg` | Unit test konversi dan pembulatan lulus |
| 2.3 | Skema Drift v1 lengkap: `customers`, `services`, `orders` (termasuk `qr_token`, `dihapus_pada`), `order_items`, `payments`, `order_status_history`, `expenses`, `settings`, `license`, `nota_counter` | `build_runner` menghasilkan kelas DB tanpa error |
| 2.4 | Konfigurasi koneksi: `PRAGMA foreign_keys=ON`, WAL, `schemaVersion = 1`, `MigrationStrategy` kosong tapi sudah ada | DB terbuka, FK menolak relasi yatim |
| 2.5 | Helper transaksi dan repository: UI tidak pernah memanggil `db` langsung | Satu test membuktikan rollback saat transaksi gagal di tengah |
| 2.6 | Harness uji migrasi: fixture DB versi lama + test migrasi | Test migrasi berjalan walau masih trivial |
| 2.7 | Tool dev: reset database, seed 50 order, generator 50.000 order untuk uji performa | Seed dan reset hanya muncul di mode debug |
| 2.8 | Indeks: `nomor_nota`, `qr_token`, telepon pelanggan, `tanggal_masuk` | `EXPLAIN QUERY PLAN` memakai indeks |

**Gerbang 2:** CRUD semua tabel lewat repository, uang dan qty punya test, data 50.000 order bisa dibuka tanpa lag.

**Keputusan yang dikunci di sini:**

- Satu order memakai satu status bersama (sesuai PRD); `order_bags` tidak dibuat sampai status per kantong benar-benar dibutuhkan.
- Nomor nota memakai tabel `nota_counter` per tanggal, dihitung di dalam transaksi yang sama dengan pembuatan order.

---

## Fase 3 — Pengaturan usaha dan layanan

Bisa paralel dengan Fase 4.

| Langkah | Isi | FR | Selesai bila |
| --- | --- | --- | --- |
| 3.1 | Wizard pertama kali: nama usaha, telepon, alamat, footer nota; bisa dilewati lalu diisi nanti | FR-31 | Instalasi baru langsung bisa membuat order tanpa mengisi ulang |
| 3.2 | Halaman pengaturan: identitas usaha, format nomor nota, ukuran label, batas hari cucian menumpuk | FR-31 | Perubahan format nota langsung dipakai order berikutnya |
| 3.3 | CRUD layanan: nama, satuan kg/pcs/meter, harga, aktif/nonaktif | FR-01 | Layanan nonaktif tidak muncul di form order baru |
| 3.4 | Validasi: harga > 0, nama tidak duplikat (tanpa peduli huruf besar/kecil), satuan wajib | FR-01 | Input salah ditolak dengan pesan yang jelas |
| 3.5 | Penyimpanan pengaturan baca-tulis lewat repository, bukan akses langsung | FR-31 | Test simpan-baca pengaturan lulus |

---

## Fase 4 — Pelanggan

| Langkah | Isi | FR | Selesai bila |
| --- | --- | --- | --- |
| 4.1 | CRUD pelanggan: nama, telepon, alamat, catatan | FR-14 | Simpan, ubah, hapus (soft) berfungsi |
| 4.2 | Normalisasi telepon `08xx` → `628xx` untuk pencarian dan WhatsApp | FR-14 | Cari dengan `0812` dan `62812` memberi hasil sama |
| 4.3 | Daftar pelanggan dengan pencarian nama/telepon, debounce 300 ms | FR-14 | Pencarian tetap responsif di 5.000 pelanggan |
| 4.4 | Peringatan duplikat saat telepon sama, tapi tetap boleh disimpan | FR-14 | Duplikat tidak memblokir kasus suami-istri satu nomor |
| 4.5 | Halaman detail pelanggan: ringkasan total order dan piutang (riwayat diisi di Fase 5) | FR-15, FR-17 | Halaman tampil walau data masih kosong |

---

## Fase 5 — Order dan nota

Inti aplikasi. Targetnya satu order selesai dicatat di bawah 60 detik.

| Langkah | Isi | FR | Selesai bila |
| --- | --- | --- | --- |
| 5.1 | Generator nomor nota: format dari pengaturan, counter per tanggal, dihitung dalam transaksi | FR-05 | 100 order berurutan tidak menghasilkan nomor kembar, termasuk setelah order dibatalkan |
| 5.2 | Form order: pilih pelanggan atau buat baru inline, tambah item, qty, subtotal, total otomatis | FR-04 | Total berubah benar saat item ditambah, diubah, dihapus |
| 5.3 | Estimasi selesai default dari layanan, bisa diubah; catatan order | FR-06, FR-08 | Default terisi otomatis, tanggal manual menang |
| 5.4 | Simpan order + item + status `Diterima` + baris riwayat dalam satu transaksi | FR-04, FR-11 | Gagal di tengah tidak meninggalkan order tanpa item |
| 5.5 | Detail order: item, total, status, riwayat singkat, aksi ubah/batalkan | FR-09 | Ubah order mencatat perubahan; batal = soft delete |
| 5.6 | Daftar order: hari ini, semua, per status; pencarian nomor nota/nama/telepon | FR-10 | Pencarian < 300 ms di 50.000 order |
| 5.7 | Diskon nominal atau persen (**P1**, boleh ditunda) | FR-07 | Total dan snapshot diskon tersimpan benar |

**Gerbang 3:** uji manual 10 order berturut-turut, semuanya di bawah 60 detik, tidak ada nomor kembar, tidak ada order tanpa item.

---

## Fase 6 — Pembayaran dan piutang

| Langkah | Isi | FR | Selesai bila |
| --- | --- | --- | --- |
| 6.1 | Catat pembayaran: jumlah, metode (tunai/transfer/QRIS manual), tanggal | FR-16 | Bisa mencatat pelunasan dan cicilan |
| 6.2 | Aturan pembayaran: tidak melebihi sisa, tidak menerima 0, soft delete | FR-16 | Unit test menolak lebih bayar dan nilai nol |
| 6.3 | Hitung piutang = total − pembayaran aktif; status lunas bila 0 | FR-17 | Unit test cocok untuk 0, 1, dan 3 pembayaran |
| 6.4 | UI bayar cepat dari detail order dan dari daftar piutang | FR-16, FR-18 | Kasir bisa melunasi tanpa membuka form order |
| 6.5 | Daftar piutang diurutkan nominal atau umur utang | FR-18 | Urutan berubah sesuai pilihan |
| 6.6 | Larang hapus permanen order yang sudah punya pembayaran | FR-09 | Aksi hapus tidak tersedia/tertolak |

---

## Fase 7 — Status, cetak nota, dan label QR

Dikerjakan sebelum scan, karena scan butuh label yang sudah tercetak.

| Langkah | Isi | FR | Selesai bila |
| --- | --- | --- | --- |
| 7.1 | State machine murni Dart: `nextStatus`, `canAdvance`, `canUndo`, status terminal | FR-11 | Unit test menutup semua transisi, termasuk dari Diambil dan order batal |
| 7.2 | Ubah status manual dengan konfirmasi, tulis `order_status_history`, tombol urungkan | FR-11, FR-36 | Setiap perubahan punya baris riwayat dengan sumber `manual` |
| 7.3 | Abstraksi `ReceiptPrinter` (scan, connect, print) supaya UI tidak bergantung plugin | FR-25 | UI tidak mengimpor paket printer langsung |
| 7.4 | Koneksi Bluetooth: pilih printer, simpan pilihan terakhir, alur izin Android 12+ | FR-25 | Printer tersambung ulang otomatis setelah aplikasi dibuka lagi |
| 7.5 | Template nota 58/80 mm: header usaha, item, qty, harga, total, dibayar, sisa, footer | FR-25, FR-33 | Cetak di printer asli, tidak ada teks terpotong |
| 7.6 | Template label 58×40 mm: nomor nota besar, nama, layanan+qty, estimasi, QR 30-40 mm EC level M, **tanpa harga** | FR-33 | Label terbaca jelas dari jarak 30 cm, tidak memuat nominal |
| 7.7 | Satu aksi cetak keduanya; cetak ulang nota dan label kapan saja | FR-33, FR-37 | Token dan nomor tidak berubah saat cetak ulang |
| 7.8 | Generate `qr_token` acak (10 karakter, tanpa karakter ambigu) dengan indeks unik | FR-35 | Tidak ada token kembar di 50.000 order seed |
| 7.9 | Fallback saat printer gagal: pesan jelas, tawarkan cetak ulang, jangan blokir penyimpanan order | FR-25 | Order tetap tersimpan walau printer mati |

**Gerbang 4:** cetak 20 label, semuanya terbaca kamera. Nota bisa direproduksi dari data order lama.

---

## Fase 8 — Scan QR

| Langkah | Isi | FR | Selesai bila |
| --- | --- | --- | --- |
| 8.1 | Layar scan: kamera belakang, hanya format QR, debounce 3 detik, senter, tombol ketik nomor nota | FR-34 | Izin kamera ditolak tetap bisa lanjut lewat input manual |
| 8.2 | Cari order lewat `qr_token`, tampilkan kartu konfirmasi: nomor, nama, status sekarang → status berikutnya | FR-34 | Kartu muncul < 1 detik setelah QR terbaca |
| 8.3 | Terapkan perubahan lewat repository status yang sama dengan jalur manual | FR-34 | Tidak ada dua implementasi aturan status |
| 8.4 | Kasus tepi: token tidak dikenal, order dibatalkan, sudah Diambil, DB kosong, label laundry lain | FR-34 | Semua kasus memberi pesan jelas dan tidak mengubah data |
| 8.5 | Urungkan dari kartu hasil scan, tercatat di riwayat | FR-36 | Urungkan mengembalikan status sebelumnya dan menulis baris riwayat |
| 8.6 | Uji beban: 30 scan berurutan pada satu label | FR-34 | Tepat 3 transisi, tidak ada lompatan |

**Gerbang 5 (vertical slice selesai):** order baru → cetak nota + label → scan tiga kali → status Diambil, semuanya di HP dan printer asli, tanpa menyentuh database manual.

---

## Fase 9 — Beranda dan daftar kerja

| Langkah | Isi | FR | Selesai bila |
| --- | --- | --- | --- |
| 9.1 | Ringkasan hari ini: jumlah order, pemasukan, piutang baru, cucian siap diambil | FR-20 | Angka cocok dengan data seed |
| 9.2 | Daftar "siap diambil" dan "belum diambil > N hari" dengan aksi cepat WhatsApp (placeholder sampai Fase 13) | FR-12 | Ambang hari mengikuti pengaturan |
| 9.3 | Aksi cepat: Order Baru dan Scan dari beranda | — | Maksimal 1 ketukan dari beranda ke form/scan |
| 9.4 | Indikator umur backup terakhir (data diisi Fase 11) | FR-30 | Slot tampil tanpa error sebelum fitur backup ada |

---

## Fase 10 — Laporan dan pengeluaran

Boleh paralel dengan Fase 11.

| Langkah | Isi | FR | Selesai bila |
| --- | --- | --- | --- |
| 10.1 | Query laporan harian/bulanan: pemasukan, jumlah order, layanan terlaris | FR-21 | Angka sama dengan hitung manual dari data seed |
| 10.2 | Halaman laporan dengan pemilih rentang tanggal | FR-21 | Rentang kosong menampilkan nol, bukan error |
| 10.3 | Pencatatan pengeluaran + laba rugi sederhana (**P1**) | FR-22, FR-23 | Laba = pemasukan − pengeluaran, diuji dengan angka negatif |
| 10.4 | Grafik tren dan ekspor PDF/Excel (**P2**, jangan dikerjakan sekarang) | FR-24 | Ditunda sampai setelah rilis |

---

## Fase 11 — Backup dan restore

Wajib selesai sebelum uji lapangan. Tanpa ini, satu HP hilang menghapus usaha orang.

| Langkah | Isi | FR | Selesai bila |
| --- | --- | --- | --- |
| 11.1 | Format file backup: SQLite + metadata JSON (versi skema, tanggal, jumlah order, checksum) | FR-28 | File bisa dibaca ulang dan divalidasi |
| 11.2 | Ekspor lewat share sheet + simpan ke folder pilihan; nama file berpola `laundry-backup-YYYYMMDD-HHmm` | FR-28 | File sampai ke Google Drive lewat share sheet |
| 11.3 | Restore: validasi checksum dan versi, buat backup otomatis data sekarang, konfirmasi eksplisit, tutup DB, ganti file, muat ulang aplikasi | FR-29 | Restore berhasil di perangkat berbeda |
| 11.4 | Tolak file rusak, file versi lebih baru, dan file bukan backup | FR-29 | Tiga skenario ditolak tanpa menyentuh data lama |
| 11.5 | Pengingat setiap 7 hari + tampilkan umur backup (**P1**) | FR-30 | Notifikasi muncul saat backup lewat 7 hari |
| 11.6 | Enkripsi backup dengan kata sandi (**P1**) | — | File terenkripsi tidak bisa dibuka tanpa sandi |

**Gerbang 6:** backup → uninstall → install → restore, data utuh. Diulang di perangkat kedua.

---

## Fase 12 — Keamanan dan poles

| Langkah | Isi | FR | Selesai bila |
| --- | --- | --- | --- |
| 12.1 | PIN 6 digit opsional + biometrik; kunci lagi setelah aplikasi di latar belakang > 5 menit | — | Salah PIN 5 kali memberi jeda |
| 12.2 | Audit UI: kontras, ukuran tombol, mode gelap, keyboard tidak menutup field, state kosong/error/loading di semua layar | — | Tidak ada layar tanpa state kosong dan error |
| 12.3 | Performa: startup < 2 detik di HP 2 GB, animasi ringan, ukuran APK dicek ulang | — | Target PRD terukur di perangkat uji |
| 12.4 | Rapikan teks Indonesia: istilah konsisten (nota, cucian, piutang), tanpa istilah teknis | — | Review teks selesai |

---

## Fase 13 — Fitur rilis 1.0

Dikerjakan setelah MVP diuji, berurutan dari yang paling cepat memberi nilai.

| Urutan | Fitur | FR | Alasan urutan |
| --- | --- | --- | --- |
| 13.1 | WhatsApp: tautan `wa.me` dengan pesan nota, "cucian selesai", pengingat utang | FR-27 | Paling cepat terasa, tanpa hardware baru |
| 13.2 | Bagikan nota PDF/gambar | FR-26 | Cadangan saat printer bermasalah |
| 13.3 | Lisensi offline: ID perangkat, verifikasi Ed25519, layar aktivasi, masa percobaan | FR-32 | Butuh ID perangkat dan alur aplikasi yang sudah stabil |
| 13.4 | Poin loyalitas | FR-19 | Butuh data pelanggan dan order yang sudah matang |
| 13.5 | Ubah status banyak order sekaligus | FR-13 | Pelengkap scan untuk kasus darurat |
| 13.6 | Kategori layanan dan layanan ekspres | FR-02, FR-03 | Menyentuh form order, kerjakan setelah form stabil |
| 13.7 | Keygen penjual (script terpisah, di luar aplikasi) | FR-32 | Alat internal, tidak memblokir aplikasi |

---

## Fase 14 — Uji perangkat, pilot, rilis

| Langkah | Isi | Selesai bila |
| --- | --- | --- |
| 14.1 | Matriks uji: Android 8, 12, 14; RAM 2 GB; dua merek printer; data 1.000 order | Semua kombinasi lulus tanpa crash |
| 14.2 | Uji migrasi dan restore dari setiap versi yang pernah dirilis | Tidak ada data hilang |
| 14.3 | Uji alur nyata: order, cetak, scan, bayar, ambil, laporan, backup | Satu siklus penuh tanpa intervensi developer |
| 14.4 | Siapkan rilis: signing key, versioning, kebijakan privasi, materi listing | APK/AAB siap dipasang |
| 14.5 | Pilot 2-3 laundry: pasang, dampingi, catat hambatan | Catatan masalah terkumpul, bukan opini |
| 14.6 | Perbaiki temuan P0, buang fitur yang tidak terpakai, rilis 1.0 | Metrik PRD terukur ulang |

---

## Yang sengaja ditunda

Jangan dikerjakan sebelum pilot selesai, walau terlihat mudah:

- Grafik tren dan ekspor Excel (FR-24)
- Status per kantong (`order_bags`)
- Kupon, promo, multi-bahasa
- Sinkronisasi multi-perangkat dan backup cloud
- Kustomisasi nota (logo, footer bergambar)

## Definisi selesai MVP

- Semua FR P0 berfungsi dan bisa didemokan di HP uji.
- Order bisa dibuat di bawah 60 detik tanpa bantuan developer.
- Satu label QR bertahan dari cetak sampai cucian diambil, termasuk saat label kotor.
- Backup dan restore terbukti di dua perangkat.
- Tidak ada data yang bisa hilang karena aplikasi ditutup paksa saat transaksi berjalan.

## Uji otomatis minimum

| Area | Jenis | Kapan |
| --- | --- | --- |
| Uang, qty, diskon, piutang | Unit test | Fase 2 dan 6 |
| Transisi status dan urungkan | Unit test | Fase 7 |
| Query nomor nota unik | Test DB | Fase 5 |
| Migrasi skema | Test DB + fixture | Fase 2, diulang tiap versi |
| Restore file rusak/versi salah | Test DB | Fase 11 |
| Form order dan scan | Widget test | Fase 5 dan 8 |
| Printer dan kamera | Uji manual di perangkat | Fase 0, 7, 8 |
