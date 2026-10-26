import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/service/presentation/services_screen.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ServicesScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('menambah layanan lewat formulir', (tester) async {
    await pumpScreen(tester);
    expect(find.text('Belum ada layanan'), findsOneWidget);

    await tester.tap(find.text('Tambah layanan'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Cuci Kering');
    await tester.enterText(find.byType(TextFormField).at(1), '7000');
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Cuci Kering'), findsOneWidget);
    expect(find.text('Rp 7.000 / kg'), findsOneWidget);
  });

  testWidgets('nama layanan ganda ditolak', (tester) async {
    await pumpScreen(tester);

    Future<void> addService(String name) async {
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), name);
      await tester.enterText(find.byType(TextFormField).at(1), '5000');
      await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
      await tester.pumpAndSettle();
    }

    await addService('Setrika');
    await addService('setrika');

    expect(find.text('Nama layanan sudah dipakai'), findsOneWidget);
  });
}
