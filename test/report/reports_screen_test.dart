import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/customer/data/customer_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/data/order_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/data/payment_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment_method.dart';
import 'package:sistem_manajemen_laundry/features/report/data/report_repository.dart';
import 'package:sistem_manajemen_laundry/features/report/presentation/reports_screen.dart';
import 'package:sistem_manajemen_laundry/features/service/data/service_repository.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final customerId = await CustomerRepository(db)
        .create(nama: 'Ibu Sari', telepon: '081234567890');
    final serviceId = await ServiceRepository(db)
        .create(nama: 'Cuci Kering', satuan: ServiceUnit.kg, harga: 7000);
    final orderId = await OrderRepository(db).create(
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
    await PaymentRepository(db).add(
      orderId: orderId,
      jumlah: 10000,
      metode: PaymentMethod.tunai,
      tanggal: DateTime.now(),
    );
    await ReportRepository(
      db,
    ).addExpense(kategori: 'Deterjen', jumlah: 4000, tanggal: DateTime.now());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('laporan harian menampilkan laba dan layanan terlaris', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ReportsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pemasukan'), findsOneWidget);
    expect(find.text('Rp 10.000'), findsOneWidget);
    expect(find.text('Rp 4.000'), findsWidgets);
    expect(find.text('Laba'), findsOneWidget);
    expect(find.text('Rp 6.000'), findsOneWidget);
    expect(find.text('Cuci Kering'), findsWidgets);
    expect(find.text('Deterjen'), findsOneWidget);
  });
}
