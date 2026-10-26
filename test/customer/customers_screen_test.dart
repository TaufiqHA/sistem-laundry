import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/customer/presentation/customers_screen.dart';

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
        child: const MaterialApp(home: CustomersScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> fillForm(
    WidgetTester tester, {
    required String name,
    required String phone,
    bool fromEmptyState = false,
  }) async {
    if (fromEmptyState) {
      await tester.tap(find.text('Tambah pelanggan'));
    } else {
      await tester.tap(find.byType(FloatingActionButton));
    }
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), name);
    await tester.enterText(find.byType(TextFormField).at(1), phone);
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
    await tester.pumpAndSettle();
  }

  testWidgets('menambah pelanggan dan menampilkan nomor dalam format lokal', (
    tester,
  ) async {
    await pumpScreen(tester);
    expect(find.text('Belum ada pelanggan'), findsOneWidget);

    await fillForm(
      tester,
      name: 'Ibu Sari',
      phone: '081234567890',
      fromEmptyState: true,
    );

    expect(find.text('Ibu Sari'), findsOneWidget);
    expect(find.textContaining('081234567890'), findsOneWidget);
  });

  testWidgets('pencarian menyaring daftar setelah jeda singkat', (
    tester,
  ) async {
    await pumpScreen(tester);
    await fillForm(
      tester,
      name: 'Budi Santoso',
      phone: '081211112222',
      fromEmptyState: true,
    );
    await fillForm(tester, name: 'Sari Dewi', phone: '081233334444');

    await tester.enterText(find.byType(TextField).first, 'sari');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    expect(find.text('Sari Dewi'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsNothing);
  });

  testWidgets('nomor ganda memunculkan peringatan tapi tetap bisa disimpan', (
    tester,
  ) async {
    await pumpScreen(tester);
    await fillForm(
      tester,
      name: 'Ibu Sari',
      phone: '081234567890',
      fromEmptyState: true,
    );

    await fillForm(tester, name: 'Pak Sari', phone: '081234567890');

    expect(find.text('Nomor sudah terdaftar'), findsOneWidget);
    await tester.tap(find.text('Tetap simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Pak Sari'), findsOneWidget);
    expect(find.text('Ibu Sari'), findsOneWidget);
  });
}
