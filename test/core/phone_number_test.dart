import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/utils/phone_number.dart';

void main() {
  group('PhoneNumber.normalize', () {
    test('mengubah awalan 0 menjadi 62', () {
      expect(PhoneNumber.normalize('081234567890'), '6281234567890');
      expect(PhoneNumber.normalize('0812-3456-7890'), '6281234567890');
      expect(PhoneNumber.normalize('0812 3456 7890'), '6281234567890');
    });

    test('menerima format internasional dan tanpa awalan', () {
      expect(PhoneNumber.normalize('+62 812 3456 7890'), '6281234567890');
      expect(PhoneNumber.normalize('6281234567890'), '6281234567890');
      expect(PhoneNumber.normalize('81234567890'), '6281234567890');
    });

    test('membuang karakter selain angka', () {
      expect(PhoneNumber.normalize('(0812) 3456.7890'), '6281234567890');
    });

    test('nomor tidak dikenal dibiarkan apa adanya', () {
      expect(PhoneNumber.normalize('12345'), '12345');
      expect(PhoneNumber.normalize(''), '');
    });
  });

  test('display mengembalikan awalan 0 untuk dibaca pengguna', () {
    expect(PhoneNumber.display('6281234567890'), '081234567890');
    expect(PhoneNumber.display('081234567890'), '081234567890');
  });

  group('validasi', () {
    test('nomor seluler Indonesia dianggap sah', () {
      expect(PhoneNumber.isValid('081234567890'), isTrue);
      expect(PhoneNumber.isValid('+6281234567890'), isTrue);
    });

    test('nomor terlalu pendek atau bukan seluler ditolak', () {
      expect(PhoneNumber.isValid('0812'), isFalse);
      expect(PhoneNumber.isValid('0211234567'), isFalse);
      expect(PhoneNumber.isValid(''), isFalse);
      expect(PhoneNumber.validate(''), isNotNull);
      expect(PhoneNumber.validate('081234567890'), isNull);
    });
  });
}
