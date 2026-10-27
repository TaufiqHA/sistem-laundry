class HomeSummary {
  const HomeSummary({
    required this.orderCount,
    required this.income,
    required this.newReceivable,
    required this.readyCount,
    required this.overdueCount,
  });

  static const empty = HomeSummary(
    orderCount: 0,
    income: 0,
    newReceivable: 0,
    readyCount: 0,
    overdueCount: 0,
  );

  /// Jumlah order yang dibuat hari ini.
  final int orderCount;

  /// Pembayaran yang diterima hari ini.
  final int income;

  /// Piutang dari order yang dibuat hari ini.
  final int newReceivable;

  /// Order berstatus Selesai yang menunggu diambil.
  final int readyCount;

  /// Order belum diambil dan sudah lewat batas hari.
  final int overdueCount;
}
