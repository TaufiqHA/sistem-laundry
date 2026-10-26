import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/utils/quantity.dart';

void main() {
  group('Quantity', () {
    test('menyimpan desimal sebagai integer 1/1000', () {
      expect(Quantity.fromDecimal(2.5), 2500);
      expect(Quantity.fromDecimal(0.125), 125);
      expect(Quantity.toDecimal(2500), 2.5);
    });

    test('format membuang nol di belakang dan memakai koma', () {
      expect(Quantity.format(2500), '2,5');
      expect(Quantity.format(2500, unit: 'kg'), '2,5 kg');
      expect(Quantity.format(3000), '3');
      expect(Quantity.format(1250, unit: 'm'), '1,25 m');
      expect(Quantity.format(0), '0');
      expect(Quantity.format(-1500, unit: 'kg'), '-1,5 kg');
    });

    test('parse menerima koma maupun titik desimal', () {
      expect(Quantity.parse('2,5'), 2500);
      expect(Quantity.parse('2.5'), 2500);
      expect(Quantity.parse('3'), 3000);
      expect(Quantity.parse('0,125'), 125);
      expect(Quantity.parse(' 2,5 '), 2500);
    });

    test('parse menolak input tidak valid', () {
      expect(Quantity.parse(''), isNull);
      expect(Quantity.parse('2,5555'), isNull);
      expect(Quantity.parse(',5'), isNull);
      expect(Quantity.parse('dua kilo'), isNull);
      expect(Quantity.parse('-2'), isNull);
    });

    test('format dan parse saling konsisten', () {
      for (final milli in [0, 125, 1000, 2500, 12345]) {
        expect(Quantity.parse(Quantity.format(milli)), milli);
      }
    });
  });
}
