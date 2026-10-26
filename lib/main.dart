import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/app.dart';
import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/core/logging/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLogger.init();
  AppLogger.installGlobalHandlers();

  // Buka database sebelum layar pertama supaya migrasi selesai lebih dulu.
  // Query trivial memaksa koneksi (dan pembuatan skema) berjalan sekarang,
  // bukan saat widget pertama meminta data.
  final database = AppDatabase();
  await database.customSelect('SELECT 1').get();
  AppLogger.log('Database siap (skema v${database.schemaVersion})');

  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const LaundryApp(),
    ),
  );
}
