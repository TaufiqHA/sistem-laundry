import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_status.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment.dart';
import 'package:sistem_manajemen_laundry/features/whatsapp/domain/whatsapp_message.dart';

void main() {
  OrderDetail detail({
    OrderStatus status = OrderStatus.selesai,
    int total = 27000,
    int dibayar = 10000,
  }) {
    return OrderDetail(
      order: LaundryOrder(
        id: 1,
        nomorNota: 'LDR-20261028-001',
        qrToken: 'TOKEN00001',
        customerId: 1,
        customerNama: 'Ibu Sari',
        customerTelepon: '6281234567890',
        tanggalMasuk: DateTime(2026, 10, 28),
        status: status,
        total: total,
        estimasiSelesai: DateTime(2026, 10, 30, 17),
      ),
      items: const [],
      history: const [],
      dibayar: dibayar,
    );
  }

  test('pesan nota memuat nomor, total, dan sisa', () {
    final text = WhatsAppMessage.invoice(
      detail(),
      businessName: 'Laundry Bersih',
    );

    expect(text, contains('Ibu Sari'));
    expect(text, contains('LDR-20261028-001'));
    expect(text, contains('Rp 27.000'));
    expect(text, contains('Rp 10.000'));
    expect(text, contains('Rp 17.000'));
    expect(text, contains('Laundry Bersih'));
  });

  test('pesan siap diambil menyebut status selesai', () {
    final text = WhatsAppMessage.ready(
      detail(),
      businessName: 'Laundry Bersih',
    );

    expect(text, contains('sudah selesai dan siap diambil'));
    expect(text, contains('Rp 17.000'));
  });

  test('pesan pengingat utang memuat nominal dan jumlah order', () {
    final text = WhatsAppMessage.debt(
      CustomerDebt(
        customerId: 1,
        nama: 'Budi',
        telepon: '6281211112222',
        piutang: 50000,
        jumlahOrder: 2,
        sejak: DateTime(2026, 10, 1),
      ),
      businessName: 'Laundry Bersih',
    );

    expect(text, contains('Budi'));
    expect(text, contains('Rp 50.000'));
    expect(text, contains('2 order'));
  });

  test('tautan wa.me memakai nomor 62 dan pesan ter-encode', () {
    final uri = WhatsAppLink.build('0812-3456-7890', 'Halo & terima kasih');

    expect(uri, isNotNull);
    expect(uri!.host, 'wa.me');
    expect(uri.path, '/6281234567890');
    expect(uri.queryParameters['text'], 'Halo & terima kasih');
  });

  test('nomor tidak valid menghasilkan tautan kosong', () {
    expect(WhatsAppLink.build('123', 'Halo'), isNull);
  });
}
