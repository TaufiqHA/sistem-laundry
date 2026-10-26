/// Nomor telepon disimpan ternormalisasi `62...` supaya pencarian dan
/// tautan WhatsApp konsisten. Tampilan tetap memakai awalan `0`.
abstract final class PhoneNumber {
  /// Membuang spasi, tanda hubung, dan kurung; mengubah `08xx` atau `8xx`
  /// menjadi `628xx`.
  ///
  /// `"0812-3456-7890"`, `"+62 812 3456 7890"`, dan `"81234567890"`
  /// menghasilkan `6281234567890`.
  static String normalize(String input) {
    var digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('62')) {
      return digits;
    }
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    if (digits.startsWith('8')) {
      return '62$digits';
    }
    return digits;
  }

  /// `6281234567890` menjadi `081234567890` untuk ditampilkan.
  static String display(String stored) {
    final normalized = normalize(stored);
    if (normalized.startsWith('62')) {
      return '0${normalized.substring(2)}';
    }
    return normalized;
  }

  /// Nomor dianggap sah jika setelah normalisasi berbentuk `62` + 8–13 digit.
  static bool isValid(String input) {
    final normalized = normalize(input);
    return RegExp(r'^628\d{7,12}$').hasMatch(normalized);
  }

  static String? validate(String? input) {
    final value = input?.trim() ?? '';
    if (value.isEmpty) {
      return 'Nomor telepon wajib diisi';
    }
    if (!isValid(value)) {
      return 'Nomor tidak valid, contoh 0812 3456 7890';
    }
    return null;
  }
}
