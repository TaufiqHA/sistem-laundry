import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/settings/data/settings_repository.dart';
import 'package:sistem_manajemen_laundry/features/settings/domain/app_settings.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(databaseProvider));
});

final settingsProvider = FutureProvider<AppSettings>((ref) async {
  return ref.watch(settingsRepositoryProvider).load();
});
