/// Seluruh teks yang tampil di layar. Dikumpulkan di sini supaya mudah
/// dirapikan dan gampang dipindah ke ARB kalau multi-bahasa dikerjakan.
abstract final class AppStrings {
  static const appName = 'Manajemen Laundry';

  // Navigasi
  static const navHome = 'Beranda';
  static const navOrders = 'Order';
  static const navCustomers = 'Pelanggan';
  static const navReports = 'Laporan';
  static const navSettings = 'Pengaturan';
  static const scan = 'Scan';

  // Keadaan kosong
  static const comingSoon = 'Segera hadir';
  static const homeEmpty = 'Belum ada aktivitas hari ini.';
  static const ordersEmpty = 'Order yang dibuat akan muncul di sini.';
  static const customersEmpty = 'Data pelanggan akan muncul di sini.';
  static const reportsEmpty = 'Laporan dibuat dari order yang sudah tercatat.';
  static const settingsEmpty = 'Pengaturan usaha dan cetak akan ada di sini.';
  static const scanEmpty =
      'Pemindai label aktif setelah nota dan label bisa dicetak.';

  // Aksi
  static const openSettings = 'Buka pengaturan';
  static const close = 'Tutup';
  static const back = 'Kembali';
}
