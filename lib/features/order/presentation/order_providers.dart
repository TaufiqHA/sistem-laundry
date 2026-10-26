import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/order/data/order_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/laundry_service.dart';
import 'package:sistem_manajemen_laundry/features/service/presentation/service_providers.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.watch(databaseProvider));
});

typedef OrderQuery = ({OrderFilter filter, String query});

final orderListProvider = FutureProvider.autoDispose
    .family<List<LaundryOrder>, OrderQuery>((ref, key) async {
      return ref
          .watch(orderRepositoryProvider)
          .list(filter: key.filter, query: key.query);
    });

final orderDetailProvider = FutureProvider.autoDispose
    .family<OrderDetail?, int>((ref, id) async {
      return ref.watch(orderRepositoryProvider).getDetail(id);
    });

final customerOrdersProvider = FutureProvider.autoDispose
    .family<List<LaundryOrder>, int>((ref, id) async {
      return ref.watch(orderRepositoryProvider).listByCustomer(id);
    });

/// Hanya layanan aktif yang boleh dipilih saat membuat order.
final activeServicesProvider = FutureProvider.autoDispose<List<LaundryService>>(
  (ref) async {
    return ref.watch(serviceRepositoryProvider).list(includeInactive: false);
  },
);
