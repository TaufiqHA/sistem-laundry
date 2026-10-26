import 'package:intl/intl.dart';

/// Uang selalu integer rupiah. Tidak ada double di jalur uang.
abstract final class Rupiah {
  static final NumberFormat _decimal = NumberFormat.decimalPattern('id');

  /// `25000` menjadi `Rp 25.000`.
  static String format(int amount) {
    final sign = amount < 0 ? '-' : '';
    return '${sign}Rp ${_decimal.format(amount.abs())}';
  }

  /// Tanpa awalan `Rp`, untuk mengisi kolom input: `25.000`.
  static String formatPlain(int amount) => _decimal.format(amount.abs());

  /// Membaca input kasir. Titik dianggap pemisah ribuan, koma ditolak
  /// karena uang tidak boleh pecahan.
  ///
  /// `"25.000"`, `"25000"`, dan `"Rp 25.000"` menghasilkan `25000`.
  /// `"25,5"`, `"-5000"`, dan teks lain menghasilkan `null`.
  static int? parse(String input) {
    final withoutCurrency = input
        .trim()
        .replaceAll(RegExp('rp', caseSensitive: false), '')
        .replaceAll(' ', '');
    if (!RegExp(r'^\d[\d.]*$').hasMatch(withoutCurrency)) {
      return null;
    }
    final digits = withoutCurrency.replaceAll('.', '');
    return int.tryParse(digits);
  }
}
