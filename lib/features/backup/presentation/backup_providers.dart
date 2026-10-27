import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/backup/data/backup_service.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(databaseProvider));
});

final localBackupsProvider = FutureProvider.autoDispose<List<File>>((
  ref,
) async {
  return ref.watch(backupServiceProvider).listLocalBackups();
});
