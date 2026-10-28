import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/customer/data/customer_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_form_page.dart';
import 'package:sistem_manajemen_laundry/features/service/data/service_repository.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seed({bool withService = true}) async {
    await CustomerRepository(db)
        .create(nama: 'Ibu Sari', telepon: '081234567890');
    if (withService) {
      await ServiceRepository(db)
          .create(nama: 'Cuci Kering', satuan: ServiceUnit.kg, harga: 7000);
    }
  }

  Future<void> pumpForm(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/order/baru',
      routes: [
        GoRoute(
          path: '/order/baru',
          builder: (context, state) => const OrderFormPage(),
        ),
        GoRoute(
          path: '/order/:id',
          builder: (context, state) =>
              const Scaffold(body: Text('detail-order')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('membuat order: pilih pelanggan, layanan, lalu simpan', (
    tester,
  ) async {
    await seed();
    await pumpForm(tester);

    await tester.tap(find.text('Pilih pelanggan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ibu Sari'));
    await tester.pumpAndSettle();
    expect(find.text('081234567890'), findsOneWidget);

    await tester.tap(find.text('Tambah layanan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cuci Kering'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Tambahkan'));
    await tester.pumpAndSettle();

    expect(find.text('Rp 7.000'), findsWidgets);
    expect(find.text('1 item'), findsOneWidget);

    await tester.tap(find.text('Simpan order'));
    await tester.pumpAndSettle();

    expect(find.text('detail-order'), findsOneWidget);
    final orders = await db.select(db.orders).get();
    expect(orders, hasLength(1));
    expect(orders.single.total, 7000);
    expect(orders.single.nomorNota, endsWith('-001'));
  });

  testWidgets('membuat layanan baru langsung dari halaman order', (
    tester,
  ) async {
    await seed(withService: false);
    await pumpForm(tester);

    expect(find.textContaining('Belum ada layanan aktif'), findsOneWidget);
    expect(find.text('Buat layanan baru'), findsOneWidget);

    await tester.tap(find.text('Buat layanan baru'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Cuci Setrika');
    await tester.enterText(find.byType(TextFormField).at(2), '9000');
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Simpan'));
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
    await tester.pumpAndSettle();

    // Dialog jumlah langsung muncul untuk layanan baru.
    await tester.tap(find.widgetWithText(FilledButton, 'Tambahkan'));
    await tester.pumpAndSettle();

    expect(find.text('1 item'), findsOneWidget);
    expect(find.text('Rp 9.000'), findsWidgets);

    final services = await ServiceRepository(db).list();
    expect(services.map((service) => service.nama), contains('Cuci Setrika'));
  });
}
