import 'dart:math';

/// Token untuk label kantong. Tanpa huruf/angka yang mudah tertukar
/// (0/O, 1/I) supaya bisa dibaca ulang saat mencetak.
abstract final class QrToken {
  static const _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static String generate({int length = 10, Random? random}) {
    final source = random ?? Random.secure();
    return List.generate(
      length,
      (_) => _alphabet[source.nextInt(_alphabet.length)],
      growable: false,
    ).join();
  }
}
