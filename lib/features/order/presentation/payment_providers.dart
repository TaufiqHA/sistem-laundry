import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/customer/presentation/customer_providers.dart';
import 'package:sistem_manajemen_laundry/features/order/data/payment_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_providers.dart';
import 'package:sistem_manajemen_laundry/features/report/presentation/report_providers.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(ref.watch(databaseProvider));
});

final paymentsProvider = FutureProvider.autoDispose.family<List<Payment>, int>((
  ref,
  orderId,
) async {
  return ref.watch(paymentRepositoryProvider).listForOrder(orderId);
});

final debtsProvider = FutureProvider.autoDispose
    .family<List<CustomerDebt>, DebtSort>((ref, sort) async {
      return ref.watch(paymentRepositoryProvider).debts(sort: sort);
    });

final totalOutstandingProvider = FutureProvider.autoDispose<int>((ref) async {
  return ref.watch(paymentRepositoryProvider).totalOutstanding();
});

/// Dipanggil setelah pembayaran berubah supaya semua angka ikut segar.
extension PaymentInvalidation on WidgetRef {
  void invalidatePaymentViews({required int orderId, required int customerId}) {
    invalidate(paymentsProvider(orderId));
    invalidate(orderDetailProvider(orderId));
    invalidate(customerSummaryProvider(customerId));
    invalidate(debtsProvider);
    invalidate(totalOutstandingProvider);
    invalidate(homeSummaryProvider);
    invalidate(readyOrdersProvider);
    invalidate(overdueOrdersProvider);
    invalidate(reportProvider);
  }
}
