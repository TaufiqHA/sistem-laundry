import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/customer/data/customer_repository.dart';
import 'package:sistem_manajemen_laundry/features/home/presentation/home_screen.dart';
import 'package:sistem_manajemen_laundry/features/order/data/order_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/data/payment_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment_method.dart';
import 'package:sistem_manajemen_laundry/features/service/data/service_repository.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';
import 'package:sistem_manajemen_laundry/features/settings/data/settings_repository.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await SettingsRepository(db).saveBusiness(
      name: 'Laundry Bersih',
      phone: '081234567890',
      address: '',
      receiptFooter: '',
    );

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
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> pumpHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('beranda menampilkan nama usaha dan ringkasan hari ini', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(find.text('Laundry Bersih'), findsOneWidget);
    expect(find.text('Order hari ini'), findsOneWidget);
    expect(find.text('Pemasukan'), findsOneWidget);
    expect(find.text('Piutang baru'), findsOneWidget);
    expect(find.text('Rp 10.000'), findsOneWidget);
    expect(find.text('Rp 7.500'), findsOneWidget);
    expect(find.text('Belum pernah backup'), findsOneWidget);
  });

  testWidgets('beranda menampilkan cucian siap diambil', (tester) async {
    final order = (await db.select(db.orders).getSingle()).id;
    final repository = OrderRepository(db);
    await repository.advanceStatus(order);
    await repository.advanceStatus(order);

    await pumpHome(tester);

    expect(find.textContaining('Siap diambil'), findsWidgets);
    expect(find.text('Ibu Sari'), findsWidgets);
  });
}
