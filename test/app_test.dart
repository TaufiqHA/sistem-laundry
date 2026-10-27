import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/app.dart';
import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/core/router/app_router.dart';
import 'package:sistem_manajemen_laundry/features/settings/data/settings_repository.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    String initialLocation = AppRoutes.home,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: LaundryApp(initialLocation: initialLocation),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('empat tab, scan, dan pengaturan bisa dibuka', (tester) async {
    await pumpApp(tester);

    expect(find.text('Order hari ini'), findsOneWidget);

    await tester.tap(find.text('Order'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada order'), findsOneWidget);

    await tester.tap(find.text('Pelanggan'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada pelanggan'), findsOneWidget);

    await tester.tap(find.text('Laporan'));
    await tester.pumpAndSettle();
    expect(find.text('Layanan terlaris'), findsOneWidget);

    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    expect(find.text('Order hari ini'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Profil usaha'), findsOneWidget);
    expect(find.text('Layanan & harga'), findsOneWidget);
  });

  testWidgets('onboarding menyimpan nama usaha lalu masuk ke beranda', (
    tester,
  ) async {
    await pumpApp(tester, initialLocation: AppRoutes.onboarding);

    expect(find.text('Atur usaha Anda'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama usaha'),
      'Laundry Bersih',
    );
    await tester.tap(find.text('Simpan dan mulai'));
    await tester.pumpAndSettle();

    expect(find.text('Order hari ini'), findsOneWidget);

    final settings = await SettingsRepository(db).load();
    expect(settings.businessName, 'Laundry Bersih');
    expect(settings.onboardingDone, isTrue);
  });

  testWidgets('onboarding bisa dilewati dan tidak muncul lagi', (tester) async {
    await pumpApp(tester, initialLocation: AppRoutes.onboarding);

    await tester.ensureVisible(find.text('Isi nanti'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Isi nanti'));
    await tester.pumpAndSettle();

    expect(find.text('Order hari ini'), findsOneWidget);
    expect(await SettingsRepository(db).isOnboardingDone(), isTrue);
  });
}
