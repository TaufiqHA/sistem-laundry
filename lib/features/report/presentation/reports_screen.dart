import 'package:flutter/material.dart';

import 'package:sistem_manajemen_laundry/core/l10n/app_strings.dart';
import 'package:sistem_manajemen_laundry/core/widgets/empty_state.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navReports)),
      body: const EmptyState(
        icon: Icons.bar_chart_outlined,
        title: 'Belum ada laporan',
        message: AppStrings.reportsEmpty,
      ),
    );
  }
}
