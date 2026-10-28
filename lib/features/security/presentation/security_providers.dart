import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/features/security/data/security_repository.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/settings_providers.dart';

final securityRepositoryProvider = Provider<SecurityRepository>((ref) {
  return SecurityRepository(ref.watch(settingsRepositoryProvider));
});

final hasPinProvider = FutureProvider<bool>((ref) async {
  return ref.watch(securityRepositoryProvider).hasPin();
});

/// Awalnya terkunci; layar kunci hanya tampil kalau PIN memang aktif.
class LockController extends Notifier<bool> {
  @override
  bool build() => true;

  void lock() => state = true;

  void unlock() => state = false;
}

final lockControllerProvider = NotifierProvider<LockController, bool>(
  LockController.new,
);
