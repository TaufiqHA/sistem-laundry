import 'package:flutter/material.dart';

import 'package:sistem_manajemen_laundry/core/l10n/app_strings.dart';
import 'package:sistem_manajemen_laundry/core/widgets/empty_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navOrders)),
      body: const EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'Belum ada order',
        message: AppStrings.ordersEmpty,
      ),
    );
  }
}
