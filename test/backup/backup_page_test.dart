import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/backup/presentation/backup_page.dart';
import 'package:sistem_manajemen_laundry/features/backup/presentation/backup_providers.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('halaman backup menampilkan aksi utama', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          localBackupsProvider.overrideWith((ref) async => <File>[]),
        ],
        child: const MaterialApp(home: BackupPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Belum pernah backup'), findsOneWidget);
    expect(find.text('Buat backup sekarang'), findsOneWidget);
    expect(find.text('Pulihkan dari file'), findsOneWidget);
  });
}
