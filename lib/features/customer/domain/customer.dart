class Customer {
  const Customer({
    required this.id,
    required this.nama,
    required this.telepon,
    this.alamat,
    this.catatan,
    this.poin = 0,
  });

  final int id;
  final String nama;

  /// Sudah ternormalisasi (`62...`). Gunakan `PhoneNumber.display` untuk UI.
  final String telepon;
  final String? alamat;
  final String? catatan;
  final int poin;

  String get initial {
    final trimmed = nama.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    return trimmed.substring(0, 1).toUpperCase();
  }
}

/// Ringkasan untuk halaman detail pelanggan.
class CustomerSummary {
  const CustomerSummary({
    required this.orderCount,
    required this.totalBelanja,
    required this.piutang,
  });

  static const empty = CustomerSummary(
    orderCount: 0,
    totalBelanja: 0,
    piutang: 0,
  );

  final int orderCount;
  final int totalBelanja;
  final int piutang;
}
