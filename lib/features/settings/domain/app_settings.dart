/// Pengaturan yang dibaca aplikasi, sudah dikonversi dari kunci-nilai.
class AppSettings {
  const AppSettings({
    this.businessName = '',
    this.businessPhone = '',
    this.businessAddress = '',
    this.receiptFooter = '',
    this.notaFormat = defaultNotaFormat,
    this.labelSize = defaultLabelSize,
    this.paperWidth = defaultPaperWidth,
    this.printerName = '',
    this.printerAddress = '',
    this.overdueDays = defaultOverdueDays,
    this.onboardingDone = false,
  });

  static const defaultNotaFormat = 'LDR-{tanggal}-{urut}';
  static const defaultLabelSize = '58x40';
  static const defaultOverdueDays = 7;
  static const defaultPaperWidth = 58;

  static const labelSizes = {'58x40': '58 × 40 mm', '58x30': '58 × 30 mm'};
  static const paperWidths = {58: '58 mm', 80: '80 mm'};

  final String businessName;
  final String businessPhone;
  final String businessAddress;
  final String receiptFooter;
  final String notaFormat;
  final String labelSize;
  final int paperWidth;
  final String printerName;
  final String printerAddress;
  final int overdueDays;
  final bool onboardingDone;

  bool get hasBusinessName => businessName.trim().isNotEmpty;

  bool get hasPrinter => printerAddress.isNotEmpty;

  String get displayName =>
      hasBusinessName ? businessName.trim() : 'Usaha belum diatur';

  /// Format nomor nota wajib memuat penanda urutan agar nomor tetap unik.
  /// `{tanggal}` dan `{urut}` diganti saat order dibuat (Fase 5).
  static String? validateNotaFormat(String value) {
    final format = value.trim();
    if (format.isEmpty) {
      return 'Format tidak boleh kosong';
    }
    if (!format.contains('{urut}')) {
      return 'Harus memuat {urut}';
    }
    if (!format.contains('{tanggal}')) {
      return 'Harus memuat {tanggal}';
    }
    if (format.length > 40) {
      return 'Maksimal 40 karakter';
    }
    return null;
  }
}
