/// Qty disimpan sebagai integer dalam 1/1000 satuan: 2,5 kg = `2500`.
/// Pembulatan hanya terjadi saat tampil, bukan saat simpan.
abstract final class Quantity {
  static const scale = 1000;

  static int fromDecimal(num value) => (value * scale).round();

  static double toDecimal(int milli) => milli / scale;

  /// `2500` dengan unit `kg` menjadi `2,5 kg`.
  static String format(int milli, {String? unit}) {
    final sign = milli < 0 ? '-' : '';
    final value = milli.abs() / scale;
    var text = value.toStringAsFixed(3).replaceFirst(RegExp(r'\.?0+$'), '');
    text = text.replaceAll('.', ',');
    return unit == null ? '$sign$text' : '$sign$text $unit';
  }

  /// Menerima koma atau titik sebagai desimal, maksimal tiga angka di
  /// belakang. `"2,5"` dan `"2.5"` sama-sama menjadi `2500`.
  static int? parse(String input) {
    final cleaned = input.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (!RegExp(r'^\d+(\.\d{1,3})?$').hasMatch(cleaned)) {
      return null;
    }
    final parts = cleaned.split('.');
    final whole = int.parse(parts[0]);
    final fraction = parts.length > 1 ? parts[1].padRight(3, '0') : '000';
    return whole * scale + int.parse(fraction);
  }
}
