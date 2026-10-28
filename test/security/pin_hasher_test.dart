import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/features/security/domain/pin_hasher.dart';

void main() {
  test('PIN harus tepat 6 angka', () {
    expect(PinHasher.validate('123456'), isNull);
    expect(PinHasher.validate('12345'), isNotNull);
    expect(PinHasher.validate('1234567'), isNotNull);
    expect(PinHasher.validate('12a456'), isNotNull);
    expect(PinHasher.validate(''), isNotNull);
  });

  test('hash bisa diverifikasi dengan PIN yang benar', () {
    final result = PinHasher.create('123456', random: Random(1));

    expect(
      PinHasher.verify('123456', hash: result.hash, salt: result.salt),
      isTrue,
    );
    expect(
      PinHasher.verify('654321', hash: result.hash, salt: result.salt),
      isFalse,
    );
  });

  test('salt berbeda menghasilkan hash berbeda', () {
    final first = PinHasher.create('123456', random: Random(1));
    final second = PinHasher.create('123456', random: Random(2));

    expect(first.salt, isNot(second.salt));
    expect(first.hash, isNot(second.hash));
  });

  test('PIN asli tidak terlihat di hash', () {
    final result = PinHasher.create('123456', random: Random(1));
    expect(result.hash.contains('123456'), isFalse);
  });
}
