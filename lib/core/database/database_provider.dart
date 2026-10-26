import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';

/// Satu instance database untuk seluruh aplikasi. Ditutup otomatis saat
/// provider dibuang (mis. saat hot restart).
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});
