# PRD Aplikasi Manajemen Laundry (Offline-First)

Oct 26, 2026 · @Taufiq
_Diperbarui Oct 27, 2026: label kantong ber-QR dan scan status masuk MVP._

## 1. Ringkasan

Aplikasi Android berbasis Flutter untuk pemilik laundry kecil yang mencatat order, pelanggan, piutang, dan laporan keuangan sepenuhnya di perangkat, tanpa server dan tanpa langganan bulanan.

Pemilik membeli aplikasi satu kali dan memakainya selama perangkatnya berfungsi. Semua data tersimpan di database lokal (SQLite) dan dilindungi lewat fitur backup ke file. Tidak ada biaya server, sehingga harga jual bisa tetap terjangkau tanpa pemasukan berulang.

| Item | Keputusan |
| --- | --- |
| Platform | Android lebih dulu (iOS menyusul jika diperlukan) |
| Framework | Flutter |
| Penyimpanan | Lokal di perangkat (SQLite lewat Drift) |
| Konektivitas | Tidak wajib; berfungsi 100% offline |
| Model bisnis | Beli sekali, lisensi offline |
| Pengguna awal | Satu perangkat utama per usaha (pemilik sebagai kasir) |
| Penandaan cucian | Label kantong ber-QR, dicetak dari printer thermal |

Setiap order menghasilkan dua cetakan: nota lengkap untuk pelanggan dan label kantong ber-QR. Karyawan memindai label untuk memajukan status, jadi status tidak lagi diubah lewat menu dan cucian tidak lagi ditandai tulisan tangan.

## 2. Latar Belakang dan Masalah

Banyak laundry kecil masih mencatat di nota kertas, sehingga pemilik kehilangan kendali atas cucian, piutang, dan keuntungan.

Masalah yang paling bisa diselesaikan lewat software:

- **Cucian tertukar atau hilang** karena penandaan manual dengan tulisan tangan yang mudah luntur atau salah baca.
- **Status tidak jelas.** Pelanggan sering bertanya "sudah selesai belum?" lewat telepon atau chat.
- **Update status makan waktu.** Karyawan harus membuka menu, mencari order, lalu memilih status satu per satu di sela pekerjaan.
- **Nota hilang atau tidak terbaca**, riwayat pelanggan tidak bisa dilacak.
- **Piutang sulit dipantau**, terutama pelanggan langganan yang membayar belakangan.
- **Keuangan tercampur** antara uang usaha dan pribadi, sehingga untung-rugi tidak diketahui.
- **Cucian tidak diambil** dan menumpuk, menahan modal dan ruang.
- **Pengelolaan pelanggan setia** (poin, promo) tidak terstruktur.

**Mengapa tanpa server.** Pemilik laundry kecil umumnya menolak langganan bulanan dan tidak selalu punya internet stabil. Model beli sekali dengan data lokal menghapus dua hambatan itu sekaligus.

**Di luar jangkauan aplikasi:** masalah operasional fisik seperti mesin rusak, cuaca, dan tenaga kerja.

## 3. Tujuan dan Metrik Keberhasilan

Tujuan utama: pemilik bisa mencatat satu order dalam kurang dari 1 menit dan tahu piutang serta pemasukan hari ini tanpa membuka buku.

**Tujuan produk**

1. Menggantikan nota kertas dengan pencatatan digital yang lebih cepat dari menulis tangan.
2. Memberi gambaran piutang dan pendapatan yang akurat setiap saat.
3. Menjamin data pemilik aman dari kehilangan perangkat lewat backup yang mudah.
4. Berjalan penuh tanpa internet dan tanpa biaya berulang.

**Metrik keberhasilan**

| Metrik | Target (usulan) | Cara mengukur |
| --- | --- | --- |
| Waktu input satu order | < 60 detik | Uji langsung dengan pemilik laundry |
| Waktu ubah status lewat scan | < 5 detik dari kamera terbuka sampai status tersimpan | Uji dengan printer dan label asli |
| Label QR terbaca pada percobaan pertama | >= 90% | Hitung manual saat uji |
| Pemilik aktif setelah 30 hari | >= 70% dari yang menginstal | Wawancara dan survei pengguna uji |
| Pemilik yang melakukan backup minimal 1x/bulan | >= 60% | Pengingat dan konfirmasi saat uji |
| Crash-free sessions | >= 99% | Crash reporting opsional (jika diizinkan pengguna) |
| Kepuasan pengguna uji | >= 4 dari 5 | Survei singkat |

Angka target di atas adalah usulan awal dan perlu disesuaikan setelah uji dengan 2-3 laundry nyata.

## 4. Target Pengguna

Pengguna utama adalah pemilik laundry kiloan atau satuan skala kecil yang bekerja sendiri atau dengan satu dua karyawan, memakai HP Android sebagai alat kerja.

| Persona | Profil | Kebutuhan utama | Kendala |
| --- | --- | --- | --- |
| **Pemilik-kasir** (utama) | Pemilik usaha, 25-50 tahun, mengelola sendiri di rumah atau kios kecil | Input order cepat, tahu piutang, cetak nota, laporan harian | Tidak mau langganan, kurang terbiasa aplikasi rumit |
| **Karyawan** (sekunder) | Membantu menerima dan menyerahkan cucian | Ubah status cucian dengan memindai label, lihat daftar siap diambil | Memakai perangkat yang sama dengan pemilik pada versi awal |
| **Pelanggan** (tidak memakai aplikasi) | Individu atau pelanggan langganan | Tahu cucian selesai, nota jelas | Menerima informasi lewat WhatsApp dan struk saja |

**Karakteristik pengguna yang memengaruhi desain**

- Layar kecil dan sering dipakai sambil berdiri atau sibuk; tombol besar dan alur pendek.
- Literasi digital beragam; istilah sederhana dalam Bahasa Indonesia.
- Internet tidak selalu tersedia; semua fitur inti harus jalan offline.
- Perangkat kelas menengah ke bawah; aplikasi harus ringan.

## 5. Ruang Lingkup

MVP mencakup pencatatan order, pelanggan, piutang, laporan dasar, backup, serta cetak nota pelanggan dan label kantong ber-QR. Scan label ikut di MVP karena menggantikan pekerjaan yang paling sering diulang setiap hari: mengubah status cucian.

| Tahap | Cakupan |
| --- | --- |
| **MVP (uji ke 2-3 laundry)** | Layanan dan harga, order dan nota, status cucian, pelanggan, pembayaran dan piutang, laporan harian dan bulanan, backup dan restore, cetak nota pelanggan, label kantong ber-QR, scan label untuk ubah status |
| **Rilis 1.0** | Bagikan nota PDF dan gambar, pesan WhatsApp otomatis terisi, pengingat backup dan cucian belum diambil, poin loyalitas, lisensi offline |
| **Setelah 1.0** | Kupon dan promo, laporan lanjutan dan grafik, ekspor Excel, kustomisasi nota (logo, footer), status per kantong, multi-bahasa |
| **Di luar lingkup (sengaja)** | Server atau akun online, sinkronisasi real-time multi-perangkat, aplikasi pelanggan, pembayaran digital terintegrasi, pengelolaan stok bahan, penggajian karyawan |

**Batasan yang disepakati sejak awal**

- Satu perangkat utama per usaha. Pemakaian di beberapa perangkat dilakukan lewat ekspor dan impor manual.
- Satu QR mewakili satu order, bukan satu kantong. Order dengan beberapa kantong memakai status bersama; status per kantong menyusul setelah 1.0.
- Pelanggan tidak memindai label. QR hanya berisi token acak dan tidak membuka data apa pun tanpa aplikasi.
- Pelanggan tidak bisa mengecek status sendiri; pemilik mengirim status lewat WhatsApp.
- Fokus Android. Cetak struk Bluetooth klasik tidak didukung di iOS.

## 6. Kebutuhan Fungsional

Tiga puluh tujuh kebutuhan di bawah dikelompokkan per modul; P0 wajib untuk MVP, P1 untuk rilis 1.0, P2 setelahnya.

### 6.1 Layanan dan harga

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| FR-01 | Tambah, ubah, dan nonaktifkan layanan (nama, satuan kg/pcs/meter, harga) | P0 |
| FR-02 | Kategori layanan (cuci kering, cuci setrika, setrika saja, selimut, dll.) | P1 |
| FR-03 | Layanan ekspres dengan tambahan biaya atau harga berbeda | P1 |

### 6.2 Order dan nota

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| FR-04 | Buat order: pilih atau tambah pelanggan, pilih layanan, isi qty, hitung total otomatis | P0 |
| FR-05 | Nomor nota otomatis dan unik (format bisa diatur, mis. LDR-20261026-001) | P0 |
| FR-06 | Tanggal masuk dan estimasi selesai (default sesuai layanan, bisa diubah) | P0 |
| FR-07 | Diskon nominal atau persen per order | P1 |
| FR-08 | Catatan per order (mis. "luntur", "noda di kerah") | P0 |
| FR-09 | Ubah atau batalkan order dengan jejak perubahan (soft delete) | P0 |
| FR-10 | Cari order berdasarkan nomor nota, nama, atau telepon | P0 |

### 6.3 Status cucian

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| FR-11 | Alur status: Diterima, Diproses, Selesai, Diambil | P0 |
| FR-12 | Daftar "siap diambil" dan "belum diambil lebih dari N hari" | P0 |
| FR-13 | Ubah status banyak order sekaligus | P1 |

Perubahan status manual tetap tersedia sebagai cadangan (mis. label hilang atau kamera bermasalah). Jalur utama di lapangan adalah scan label, diatur di 6.8.

### 6.4 Pelanggan dan piutang

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| FR-14 | Data pelanggan: nama, telepon, alamat, catatan | P0 |
| FR-15 | Riwayat order per pelanggan | P0 |
| FR-16 | Pembayaran penuh atau cicilan; metode tunai, transfer, QRIS manual | P0 |
| FR-17 | Piutang per pelanggan dihitung dari total order dikurangi pembayaran | P0 |
| FR-18 | Daftar pelanggan yang masih berutang, diurutkan nominal atau umur utang | P0 |
| FR-19 | Poin loyalitas dan penukaran | P1 |

### 6.5 Laporan

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| FR-20 | Ringkasan hari ini: jumlah order, pemasukan, piutang baru, cucian siap diambil | P0 |
| FR-21 | Laporan harian dan bulanan (pemasukan, jumlah order, layanan terlaris) | P0 |
| FR-22 | Pencatatan pengeluaran (listrik, deterjen, gaji, dll.) | P1 |
| FR-23 | Laba rugi sederhana: pemasukan dikurangi pengeluaran | P1 |
| FR-24 | Grafik tren dan ekspor laporan ke PDF atau Excel | P2 |

### 6.6 Struk dan komunikasi

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| FR-25 | Cetak struk ke printer thermal Bluetooth (58 mm dan 80 mm), termasuk cetak QR di label | P0 |
| FR-26 | Bagikan nota sebagai PDF atau gambar | P1 |
| FR-27 | Kirim pesan WhatsApp (nota, "cucian selesai", pengingat utang) lewat tautan `wa.me` dengan pesan terisi | P1 |

### 6.7 Backup, pengaturan, dan lisensi

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| FR-28 | Backup manual ke file; simpan ke penyimpanan HP atau bagikan ke Google Drive lewat share sheet | P0 |
| FR-29 | Restore dari file backup dengan validasi versi dan konfirmasi sebelum menimpa data | P0 |
| FR-30 | Pengingat backup berkala (mis. setiap 7 hari) dan backup otomatis ke folder lokal | P1 |
| FR-31 | Pengaturan usaha: nama, alamat, telepon, footer nota, format nomor nota, ukuran label | P0 |
| FR-32 | Aktivasi lisensi offline dengan kode yang terikat perangkat | P1 |

### 6.8 Label kantong dan scan QR

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| FR-33 | Cetak dua varian dalam satu alur: nota pelanggan (rincian item dan pembayaran) dan label kantong (nomor nota besar, nama, layanan, qty, estimasi selesai, QR; tanpa harga) | P0 |
| FR-34 | Scan QR label dengan kamera untuk memajukan status tepat satu tahap, dengan kartu konfirmasi sebelum disimpan | P0 |
| FR-35 | QR berisi `LDR1:<nomor_nota>:<token_acak>`; status selalu dibaca dari database saat scan, bukan dari QR | P0 |
| FR-36 | Riwayat perubahan status per order: status lama, status baru, waktu, sumber (manual atau scan), dan aksi urungkan | P0 |
| FR-37 | Cetak ulang label kapan saja; nomor nota dan token tidak berubah | P0 |

**Aturan scan.**

- Aplikasi membaca status terakhir dari database lalu menawarkan satu tahap berikutnya. Scan tidak pernah melompati tahap.
- Order berstatus Diambil atau sudah dibatalkan tidak bisa dimajukan; aplikasi menampilkan tanggal dan status terakhirnya.
- Scan ganda dalam 3 detik diabaikan agar satu label tidak memajukan dua tahap.
- Setelah status tersimpan, tampil tombol **Urungkan** yang mencatat pembatalan di `order_status_history`.
- Jika QR tidak terbaca, kasir mengetik nomor nota di layar yang sama. Kamera yang gagal tidak boleh memblokir pekerjaan.
- Label dicetak pada stiker 58×40 mm atau kertas struk yang dimasukkan ke kantong plastik, menyesuaikan printer yang dipakai.

### 6.9 Contoh alur utama: buat order

1. Kasir membuka aplikasi dan menekan **Order Baru**.
2. Pilih pelanggan dari daftar, atau ketik nama dan telepon untuk pelanggan baru.
3. Pilih layanan dan isi berat atau jumlah; total terhitung otomatis.
4. Atur estimasi selesai dan catatan jika perlu.
5. Pilih pembayaran: lunas, bayar sebagian, atau bayar nanti.
6. Simpan, lalu cetak nota pelanggan dan label kantong ber-QR dalam satu perintah.
7. Tempel label di kantong cucian dan serahkan nota ke pelanggan.

### 6.10 Contoh alur utama: dari cucian masuk sampai diambil

1. Order disimpan dan label kantong dicetak. Status awal **Diterima**.
2. Cucian masuk mesin. Karyawan membuka **Scan**, mengarahkan kamera ke label, lalu menekan **Ubah ke Diproses**.
3. Selesai dicuci dan disetrika. Scan lagi, konfirmasi, status menjadi **Selesai**.
4. Order muncul di daftar "siap diambil". Pemilik mengirim pesan WhatsApp ke pelanggan.
5. Pelanggan datang dan membayar sisa. Scan label terakhir, status menjadi **Diambil**.
6. Jika salah scan, karyawan menekan **Urungkan** pada kartu hasil scan; perubahan tercatat di riwayat.

## 7. Kebutuhan Non-Fungsional

Karena tidak ada server untuk memperbaiki data dari jauh, keandalan data dan kemudahan backup menjadi syarat utama, di atas kecanggihan fitur.

| Aspek | Kebutuhan |
| --- | --- |
| **Offline** | Semua fitur inti berjalan tanpa internet. Internet hanya dipakai saat berbagi file atau membuka WhatsApp. Pemindaian QR berjalan penuh di perangkat dan gambar kamera tidak dikirim ke mana pun. |
| **Integritas data** | Semua perubahan multi-tabel (order, item, pembayaran) dalam satu transaksi database. Uang disimpan sebagai integer rupiah, bukan desimal. Soft delete untuk order dan pembayaran. |
| **Migrasi database** | Setiap perubahan skema punya migrasi tertulis dan diuji dari semua versi lama. Backup otomatis dibuat sebelum migrasi dijalankan. |
| **Backup** | File backup berisi tanggal dan versi skema, bisa dipulihkan di perangkat lain. Pengingat jika backup terakhir lebih dari 7 hari. |
| **Keamanan** | PIN atau biometrik opsional untuk membuka aplikasi. Backup bisa dienkripsi dengan kata sandi (opsional). Tidak ada data dikirim ke luar perangkat tanpa tindakan pemilik. Token QR dibuat acak dan tidak berurutan, sehingga label laundry lain tidak bisa ditebak atau dipalsukan. |
| **Performa** | Buka aplikasi < 2 detik di HP kelas menengah bawah. Pencarian order tetap cepat pada 50.000 order (indeks pada nomor nota, telepon, tanggal). Hasil scan tampil < 1 detik (indeks pada `qr_token`). |
| **Kompatibilitas** | Android 8.0 (API 26) ke atas. Izin Bluetooth Android 12+ (`BLUETOOTH_CONNECT`, `BLUETOOTH_SCAN`) dan izin kamera ditangani dengan benar. |
| **Ukuran aplikasi** | Target < 30 MB. |
| **Usability** | Bahasa Indonesia, tombol dan teks besar, maksimal 3 ketukan untuk tindakan utama, mode terang dan gelap. Scan label menjadi jalur tercepat mengubah status: satu ketukan setelah kartu konfirmasi muncul. |
| **Privasi** | Tidak ada pelacakan atau iklan. Crash reporting hanya jika pengguna mengaktifkannya. |
| **Pemeliharaan** | Kode modular per fitur, ada uji otomatis untuk perhitungan uang, piutang, transisi status, dan migrasi. |

Angka performa dan ukuran adalah target awal yang perlu diverifikasi di perangkat uji nyata.

## 8. Arsitektur dan Stack Teknis

Aplikasi Flutter tanpa backend: semua logika bisnis dan data berjalan di perangkat, dan hanya berhubungan dengan luar saat pemilik membagikan file, mencetak, atau membuka WhatsApp.

&#91;embedded content: arsitektur offline-first · 4 lapisan, 3 sambungan keluar\]

Pemilik memicu setiap sambungan keluar sendiri: membuka WhatsApp, mencetak nota atau label, atau menyimpan file backup.

| Kebutuhan | Paket | Catatan |
| --- | --- | --- |
| Database lokal | `drift` (SQLite) | Type-safe, ada migrasi, mendukung query laporan |
| State management | `flutter_riverpod` | Mudah diuji, rapi saat aplikasi membesar |
| Navigasi | `go_router` |  |
| Printer thermal | `print_bluetooth_thermal`, `esc_pos_utils_plus` | Nota, label kantong, dan QR lewat perintah ESC/POS; uji dengan printer asli sejak awal |
| PDF dan cetak | `pdf`, `printing` | Nota PDF dan laporan; QR digambar dengan `BarcodeWidget` |
| Scan QR | `mobile_scanner` | Kamera belakang, offline, hanya membaca format QR |
| WhatsApp | `url_launcher` | Tautan `wa.me` dengan pesan terisi |
| Backup dan restore | `path_provider`, `file_picker`, `share_plus` | Ekspor file database lewat share sheet |
| Grafik | `fl_chart` | Laporan tren (P2) |
| Format rupiah dan tanggal | `intl` |  |
| Pengingat lokal | `flutter_local_notifications` | Pengingat backup dan cucian belum diambil |
| Lisensi offline | `cryptography` (Ed25519), `device_info_plus` | Kunci privat di penjual, kunci publik di aplikasi |

**Struktur folder (feature-first)**

```text
lib/
  core/        # database, tema, util, format rupiah
  features/
    order/     # input order, status, nota
    scan/      # pemindai QR label dan perubahan status
    customer/  # pelanggan, piutang
    service/   # daftar layanan dan harga
    report/    # laporan harian dan bulanan
    backup/    # ekspor dan impor
    printer/   # nota, label kantong, dan QR
    license/   # aktivasi
  main.dart
```

**Keputusan arsitektur**

- Antarmuka tidak mengakses database langsung; semua lewat repository agar logika uang dan piutang mudah diuji.
- Perubahan lintas tabel (order, item, pembayaran) selalu dalam satu transaksi.
- Hasil scan hanya dipakai untuk mencari order lewat `qr_token`; perubahan status tetap melewati repository yang sama dengan perubahan manual, sehingga aturan maju-satu-tahap dan riwayat berlaku di kedua jalur.
- Android lebih dulu; iOS hanya mendukung printer BLE, sehingga cetak struk terbatas di sana.

## 9. Model Data dan Aturan Bisnis

Seluruh data berada dalam satu database SQLite; piutang tidak disimpan sebagai kolom, tetapi dihitung dari total order dikurangi pembayaran.

| Tabel | Kolom utama | Keterangan |
| --- | --- | --- |
| `customers` | id, nama, telepon, alamat, catatan, poin, dibuat\_pada | Telepon dipakai untuk WhatsApp dan pencarian |
| `services` | id, nama, kategori, satuan, harga, aktif | Layanan dinonaktifkan, tidak dihapus, agar riwayat tetap utuh |
| `orders` | id, nomor\_nota, customer\_id, tanggal\_masuk, estimasi\_selesai, status, diskon, total, catatan, qr\_token, dihapus\_pada | `total` disimpan sebagai snapshot saat order dibuat; `qr_token` acak dan unik untuk label kantong |
| `order_items` | id, order\_id, service\_id, nama\_layanan, qty, harga\_satuan, subtotal | Nama dan harga disalin agar perubahan harga tidak mengubah order lama |
| `order_status_history` | id, order\_id, status\_lama, status\_baru, sumber, diubah\_pada | `sumber` berisi manual atau scan; dipakai untuk urungkan dan jejak audit |
| `payments` | id, order\_id, jumlah, metode, tanggal, dihapus\_pada | Satu order bisa punya banyak pembayaran (cicilan) |
| `expenses` | id, kategori, jumlah, tanggal, catatan | Untuk laba rugi sederhana |
| `settings` | kunci, nilai | Nama usaha, footer nota, format nomor nota, pengaturan backup |
| `license` | kode, id\_perangkat, diaktifkan\_pada | Hasil aktivasi lisensi offline |

**Aturan bisnis**

- Semua nilai uang disimpan sebagai integer rupiah.
- Piutang order = `total` dikurangi jumlah pembayaran yang belum dihapus. Order lunas jika hasilnya 0.
- Status order hanya maju: Diterima, Diproses, Selesai, Diambil. Mundur diperbolehkan dengan konfirmasi dan dicatat.
- Scan berhenti di Diambil. Order yang sudah Diambil atau dibatalkan tidak bisa dimajukan lewat scan; mundur dari Diambil hanya lewat perubahan manual dengan konfirmasi dan tercatat di riwayat.
- QR label hanya membawa nomor nota dan token acak. Status tidak pernah disimpan di dalam QR, sehingga label lama tetap benar walau status sudah berubah.
- Token QR unik dan tidak berubah walau label dicetak ulang atau order dibatalkan.
- Label kantong tidak memuat harga; nota pelanggan memuat rincian item, total, dan sisa pembayaran.
- Satu order memakai satu status bersama untuk seluruh kantongnya.
- Nomor nota unik dan tidak dipakai ulang, bahkan setelah order dibatalkan.
- Order tidak bisa dihapus permanen setelah ada pembayaran; hanya dibatalkan (soft delete).
- Mengubah harga layanan tidak mengubah order yang sudah dibuat.
- Cucian yang belum diambil melewati batas hari tertentu (default 7) masuk daftar peringatan.

## 10. Model Bisnis dan Lisensi

Pemasukan berasal dari penjualan satu kali per usaha; supaya tetap berkelanjutan, update versi besar dan layanan tambahan bisa berbayar tanpa memutus pembeli lama.

**Sumber pemasukan**

| Sumber | Skema |
| --- | --- |
| Penjualan aplikasi | Beli sekali, pakai selamanya pada versi yang dibeli |
| Update kecil (perbaikan bug, penyesuaian) | Gratis untuk semua pembeli |
| Update versi besar (v2, v3) | Berbayar atau diskon untuk pembeli lama |
| Layanan opsional | Backup cloud, sinkronisasi multi-perangkat, jasa setup, paket printer. Aplikasi tetap penuh tanpa semua ini. |

**Lisensi offline**

1. Pembeli mengirim ID perangkat yang ditampilkan di aplikasi.
2. Penjual membuat kode lisensi dengan tanda tangan digital (Ed25519) menggunakan kunci privat yang hanya dimiliki penjual.
3. Aplikasi memverifikasi kode memakai kunci publik yang tertanam, tanpa internet.
4. Pemindahan ke perangkat baru lewat kode lisensi baru atau jumlah pemindahan terbatas yang ditentukan penjual.

**Keputusan yang perlu diambil**

- Harga jual: perlu riset ke 5-10 laundry dan aplikasi pesaing sebelum ditetapkan.
- Saluran penjualan: Google Play (berbayar), penjualan langsung dengan kode lisensi, atau keduanya.
- Masa percobaan: mis. 14 hari atau batas 30 order sebelum aktivasi.

**Catatan realistis.** Pembajakan APK tidak bisa dicegah sepenuhnya. Lisensi dibuat cukup sederhana agar tidak mengganggu pembeli sah, dan nilai tambah (update, dukungan, kemudahan backup) menjadi alasan membeli.

## 11. Risiko dan Mitigasi

Risiko terbesar adalah kehilangan data pemilik, karena tidak ada salinan di server yang bisa dipulihkan.

| Risiko | Dampak | Mitigasi |
| --- | --- | --- |
| HP hilang, rusak, atau di-reset | Seluruh data usaha hilang | Pengingat backup, backup otomatis ke folder lokal, panduan restore sederhana, saran menyimpan backup ke Google Drive |
| Migrasi database gagal saat update | Data rusak atau tidak terbaca | Backup otomatis sebelum migrasi, uji upgrade dari semua versi lama, perbaikan lewat update |
| Printer Bluetooth tidak kompatibel | Fitur cetak gagal, banyak keluhan | Uji dengan beberapa merek populer, dukung 58 mm dan 80 mm, sediakan fallback PDF dan WhatsApp |
| Label QR kotor, terlipat, atau cetak pudar | Status tidak bisa diubah lewat scan | QR 30-40 mm dengan error correction level M, cetak ulang label kapan saja, fallback ketik nomor nota |
| Salah scan atau kamera membaca label dua kali | Status melompat satu tahap | Kartu konfirmasi sebelum simpan, abaikan scan ganda dalam 3 detik, tombol urungkan dengan riwayat |
| Order berisi beberapa kantong yang selesai tidak bersamaan | Status bersama tidak mencerminkan kondisi tiap kantong | Jelaskan batasan satu status per order di MVP; status per kantong masuk daftar setelah 1.0 |
| Pelanggan memindai label dengan HP sendiri | Data order terbaca pihak lain | QR hanya berisi nomor nota dan token acak; tanpa aplikasi tidak ada data yang terbuka, dan token tidak bisa ditebak |
| Printer hanya mendukung kertas struk, bukan stiker | Label tidak bisa ditempel | Cetak label di kertas struk lalu masukkan ke kantong plastik bersama cucian |
| Izin Bluetooth Android 12+ salah ditangani | Printer tidak terdeteksi | Alur izin dan pesan bantuan yang jelas |
| Izin kamera ditolak atau kamera bermasalah | Scan label tidak bisa dipakai | Tombol "ketik nomor nota" di layar scan, pesan bantuan izin, dan jalur ubah status manual |
| Lebih dari satu kasir dengan perangkat berbeda | Data tidak sinkron | Tegaskan batasan satu perangkat utama; layanan sinkronisasi opsional pada versi lanjutan |
| Pembajakan APK | Pendapatan hilang | Terima sebagian; beri nilai tambah lewat update dan dukungan |
| Tanpa pemasukan berulang, biaya dukungan menekan | Proyek sulit berlanjut | Update besar berbayar, layanan opsional, harga awal yang memadai |
| Pemilik tidak disiplin backup | Kehilangan data tetap terjadi | Pengingat tegas, tampilkan umur backup terakhir di layar utama |
| Perangkat Android kelas bawah lambat | Pengalaman buruk | Uji di perangkat RAM 2-3 GB, hindari animasi berat, indeks database |
| Fitur terlalu banyak, MVP molor | Rilis tertunda | Patuhi cakupan MVP, uji ke pengguna nyata sebelum menambah fitur. Label QR dan scan sudah dihitung di MVP; fitur yang menyusul (status per kantong, WhatsApp otomatis) ditahan sampai uji selesai |

## 13. Asumsi dan Pertanyaan Terbuka

PRD ini bertumpu pada beberapa asumsi yang perlu dibuktikan lewat wawancara dengan pemilik laundry sebelum fitur dikunci.

**Asumsi**

- Pemilik laundry target memakai HP Android dan bekerja dengan satu perangkat utama.
- Pemilik bersedia membayar sekali di awal dan lebih memilih itu daripada langganan.
- Printer thermal Bluetooth sudah umum dimiliki atau bisa dibeli terjangkau.
- Printer yang dipakai mendukung perintah QR ESC/POS dan pemilik bersedia memakai kertas label stiker, atau kertas struk yang dimasukkan ke kantong plastik.
- Karyawan memindai label memakai HP pemilik yang sama, bukan perangkat terpisah.
- Pengiriman status lewat WhatsApp manual cukup, tanpa perlu notifikasi otomatis.

**Pertanyaan terbuka**

- [ ] Berapa harga jual yang masih dianggap wajar oleh pemilik laundry kecil?
- [ ] Apakah ada karyawan yang perlu menginput di perangkat berbeda? Jika sering, sinkronisasi lokal lewat Wi-Fi perlu masuk ke 1.0.
- [ ] Laundry kiloan, satuan, atau keduanya yang menjadi fokus awal?
- [ ] Apakah perlu pengelolaan stok bahan (deterjen, pewangi) pada versi awal?
- [ ] Google Play berbayar atau penjualan langsung dengan kode lisensi?
- [ ] Apakah perlu dukungan iOS, mengingat keterbatasan printer Bluetooth di sana?
- [ ] Siapa 2-3 laundry yang akan menjadi penguji MVP?
- [ ] Merek printer thermal apa yang paling banyak dipakai di target pasar? Pastikan modelnya bisa mencetak QR.
- [ ] Satu order biasanya berisi berapa kantong? Jika hampir selalu lebih dari satu, status per kantong perlu naik ke MVP.
- [ ] Label dicetak di stiker 58×40 mm atau kertas struk yang dimasukkan ke kantong plastik?
- [ ] Apakah scan pertama perlu konfirmasi, atau langsung memindahkan status ke Diproses?
