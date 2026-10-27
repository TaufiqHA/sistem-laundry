import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/features/scan/domain/qr_payload.dart';

void main() {
  test('membaca payload label yang sah', () {
    final payload = QrPayload.parse('LDR1:LDR-20261027-001:TOKEN00001');

    expect(payload, isNotNull);
    expect(payload!.nota, 'LDR-20261027-001');
    expect(payload.token, 'TOKEN00001');
  });

  test('membuang spasi di awal dan akhir', () {
    final payload = QrPayload.parse('  LDR1:LDR-20261027-001:TOKEN00001  ');
    expect(payload?.token, 'TOKEN00001');
  });

  test('menolak QR dari luar aplikasi', () {
    expect(QrPayload.parse('https://contoh.com/nota/1'), isNull);
    expect(QrPayload.parse('LDR2:LDR-20261027-001:TOKEN00001'), isNull);
    expect(QrPayload.parse('LDR1:LDR-20261027-001'), isNull);
    expect(QrPayload.parse('LDR1::TOKEN00001'), isNull);
    expect(QrPayload.parse('LDR1:LDR-20261027-001:PENDEK'), isNull);
    expect(QrPayload.parse(''), isNull);
  });
}
