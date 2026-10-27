import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_status.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/scan_result.dart';
import 'package:sistem_manajemen_laundry/features/scan/presentation/scan_result_panel.dart';

void main() {
  OrderDetail detailWith(OrderStatus status) {
    return OrderDetail(
      order: LaundryOrder(
        id: 1,
        nomorNota: 'LDR-20261027-001',
        qrToken: 'TOKEN00001',
        customerId: 1,
        customerNama: 'Ibu Sari',
        customerTelepon: '6281234567890',
        tanggalMasuk: DateTime(2026, 10, 27),
        status: status,
        total: 17500,
      ),
      items: const [],
      history: const [],
      dibayar: 0,
    );
  }

  Future<void> pumpPanel(WidgetTester tester, ScanResult result) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScanResultPanel(
            result: result,
            onAdvance: () {},
            onClose: () {},
          ),
        ),
      ),
    );
  }

  testWidgets('order siap menampilkan tombol ubah status', (tester) async {
    await pumpPanel(
      tester,
      ScanResult(ScanOutcome.siap, detail: detailWith(OrderStatus.diterima)),
    );

    expect(find.text('LDR-20261027-001'), findsOneWidget);
    expect(find.text('Ibu Sari'), findsOneWidget);
    expect(find.text('Ubah ke Diproses'), findsOneWidget);
  });

  testWidgets('order yang sudah diambil tidak menampilkan tombol', (
    tester,
  ) async {
    await pumpPanel(
      tester,
      ScanResult(
        ScanOutcome.sudahDiambil,
        detail: detailWith(OrderStatus.diambil),
      ),
    );

    expect(find.textContaining('sudah diambil'), findsOneWidget);
    expect(find.text('Ubah ke Diproses'), findsNothing);
  });

  testWidgets('QR asing menampilkan penjelasan', (tester) async {
    await pumpPanel(tester, const ScanResult(ScanOutcome.tidakValid));

    expect(find.text('QR bukan dari aplikasi ini'), findsOneWidget);
    expect(find.textContaining('bukan buatan aplikasi'), findsOneWidget);
  });
}
