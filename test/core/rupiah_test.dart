import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';

void main() {
  group('Rupiah.format', () {
    test('nol dan ribuan memakai pemisah titik', () {
      expect(Rupiah.format(0), 'Rp 0');
      expect(Rupiah.format(25000), 'Rp 25.000');
      expect(Rupiah.format(1234567), 'Rp 1.234.567');
    });

    test('nilai negatif diberi tanda minus di depan', () {
      expect(Rupiah.format(-5000), '-Rp 5.000');
    });
  });

  group('Rupiah.parse', () {
    test('menerima format yang biasa diketik kasir', () {
      expect(Rupiah.parse('25.000'), 25000);
      expect(Rupiah.parse('25000'), 25000);
      expect(Rupiah.parse('Rp 25.000'), 25000);
      expect(Rupiah.parse('  1.000.000  '), 1000000);
      expect(Rupiah.parse('Rp0'), 0);
    });

    test('menolak pecahan, negatif, dan teks', () {
      expect(Rupiah.parse('25,5'), isNull);
      expect(Rupiah.parse('25.000,50'), isNull);
      expect(Rupiah.parse('-5000'), isNull);
      expect(Rupiah.parse(''), isNull);
      expect(Rupiah.parse('abc'), isNull);
      expect(Rupiah.parse('.'), isNull);
    });

    test('hasil format bisa dibaca ulang', () {
      const amount = 987654;
      expect(Rupiah.parse(Rupiah.format(amount)), amount);
    });
  });
}
