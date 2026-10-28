import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// PIN disimpan sebagai hash bergaram, bukan teks asli.
abstract final class PinHasher {
  static const length = 6;
  static const _iterations = 1000;

  static String? validate(String pin) {
    return RegExp(r'^\d{6}$').hasMatch(pin) ? null : 'PIN harus 6 angka';
  }

  static ({String hash, String salt}) create(String pin, {Random? random}) {
    final source = random ?? Random.secure();
    final saltBytes = List<int>.generate(16, (_) => source.nextInt(256));
    final salt = base64Encode(saltBytes);
    return (hash: _digest(pin, salt), salt: salt);
  }

  static bool verify(String pin, {required String hash, required String salt}) {
    return _digest(pin, salt) == hash;
  }

  /// Diulang beberapa kali agar menebak PIN tidak secepat hash tunggal.
  static String _digest(String pin, String salt) {
    var value = sha256.convert(utf8.encode('$salt:$pin')).toString();
    for (var index = 1; index < _iterations; index++) {
      value = sha256.convert(utf8.encode(value)).toString();
    }
    return value;
  }
}
