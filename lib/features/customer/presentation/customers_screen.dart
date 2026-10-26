import 'package:flutter/material.dart';

import 'package:sistem_manajemen_laundry/core/l10n/app_strings.dart';
import 'package:sistem_manajemen_laundry/core/widgets/empty_state.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navCustomers)),
      body: const EmptyState(
        icon: Icons.people_outline,
        title: 'Belum ada pelanggan',
        message: AppStrings.customersEmpty,
      ),
    );
  }
}
