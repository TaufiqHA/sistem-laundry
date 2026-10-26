import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/customer/data/customer_repository.dart';
import 'package:sistem_manajemen_laundry/features/customer/domain/customer.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(ref.watch(databaseProvider));
});

final customerSearchProvider = FutureProvider.autoDispose
    .family<List<Customer>, String>((ref, query) async {
      return ref.watch(customerRepositoryProvider).list(query: query);
    });

final customerDetailProvider = FutureProvider.autoDispose
    .family<Customer?, int>((ref, id) async {
      return ref.watch(customerRepositoryProvider).getById(id);
    });

final customerSummaryProvider = FutureProvider.autoDispose
    .family<CustomerSummary, int>((ref, id) async {
      return ref.watch(customerRepositoryProvider).summary(id);
    });
