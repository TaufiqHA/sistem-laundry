import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/customer/data/customer_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/data/order_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_detail_page.dart';
import 'package:sistem_manajemen_laundry/features/service/data/service_repository.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

void main() {
  late AppDatabase db;
  late int orderId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final customerId = await CustomerRepository(db)
        .create(nama: 'Ibu Sari', telepon: '081234567890');
    final serviceId = await ServiceRepository(db)
        .create(nama: 'Cuci Kering', satuan: ServiceUnit.kg, harga: 7000);
    orderId = await OrderRepository(db).create(
      customerId: customerId,
      items: [
        NewOrderItem(
          serviceId: serviceId,
          namaLayanan: 'Cuci Kering',
          qtyMilli: 2500,
          hargaSatuan: 7000,
          satuan: ServiceUnit.kg,
        ),
      ],
      estimasiSelesai: DateTime.now().add(const Duration(days: 2)),
    );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('mencatat pembayaran dari halaman detail order', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(home: OrderDetailPage(orderId: orderId)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Catat pembayaran'), findsOneWidget);
    expect(find.text('Belum ada pembayaran'), findsOneWidget);

    await tester.ensureVisible(find.text('Catat pembayaran'));
    await tester.tap(find.text('Catat pembayaran'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Simpan pembayaran'),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan pembayaran'));
    await tester.pumpAndSettle();

    expect(find.text('Catat pembayaran'), findsNothing);
    expect(find.text('Belum ada pembayaran'), findsNothing);
    expect(find.textContaining('Tunai'), findsOneWidget);
    expect(find.text('Rp 0'), findsWidgets);

    final payments = await db.select(db.payments).get();
    expect(payments, hasLength(1));
    expect(payments.single.jumlah, 17500);
  });
}
