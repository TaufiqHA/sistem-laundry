import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/features/order/domain/order_status.dart';

void main() {
  test('status maju satu per satu sampai Diambil', () {
    expect(OrderStatus.diterima.next, OrderStatus.diproses);
    expect(OrderStatus.diproses.next, OrderStatus.selesai);
    expect(OrderStatus.selesai.next, OrderStatus.diambil);
    expect(OrderStatus.diambil.next, isNull);
  });

  test('hanya Diambil yang final', () {
    expect(OrderStatus.diterima.isFinal, isFalse);
    expect(OrderStatus.diproses.isFinal, isFalse);
    expect(OrderStatus.selesai.isFinal, isFalse);
    expect(OrderStatus.diambil.isFinal, isTrue);
    expect(OrderStatus.diambil.canAdvance, isFalse);
    expect(OrderStatus.diterima.canAdvance, isTrue);
  });

  test('label status dipakai di UI', () {
    expect(OrderStatus.values.map((status) => status.label), [
      'Diterima',
      'Diproses',
      'Selesai',
      'Diambil',
    ]);
  });
}
