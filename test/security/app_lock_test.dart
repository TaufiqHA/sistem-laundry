import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/security/data/security_repository.dart';
import 'package:sistem_manajemen_laundry/features/security/presentation/app_lock_gate.dart';
import 'package:sistem_manajemen_laundry/features/settings/data/settings_repository.dart';

void main() {
  late AppDatabase db;
  late SecurityRepository security;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    security = SecurityRepository(SettingsRepository(db));
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> pumpGate(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
          home: AppLockGate(child: Scaffold(body: Text('isi aplikasi'))),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('tanpa PIN aplikasi langsung terbuka', (tester) async {
    await pumpGate(tester);

    expect(find.text('Aplikasi terkunci'), findsNothing);
    expect(find.text('isi aplikasi'), findsOneWidget);
  });

  testWidgets('PIN benar membuka kunci', (tester) async {
    await security.setPin('123456');
    await pumpGate(tester);

    expect(find.text('Aplikasi terkunci'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pumpAndSettle();

    expect(find.text('Aplikasi terkunci'), findsNothing);
    expect(find.text('isi aplikasi'), findsOneWidget);
  });

  testWidgets('PIN salah menampilkan pesan dan tetap terkunci', (tester) async {
    await security.setPin('123456');
    await pumpGate(tester);

    await tester.enterText(find.byType(TextField), '000000');
    await tester.pumpAndSettle();

    expect(find.textContaining('PIN salah'), findsOneWidget);
    expect(find.text('Aplikasi terkunci'), findsOneWidget);
  });
}
