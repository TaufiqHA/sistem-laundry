import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/service/data/service_repository.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/laundry_service.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository(ref.watch(databaseProvider));
});

final serviceListProvider = FutureProvider<List<LaundryService>>((ref) async {
  return ref.watch(serviceRepositoryProvider).list();
});
