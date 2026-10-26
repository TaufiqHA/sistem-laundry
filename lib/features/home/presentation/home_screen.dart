import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/l10n/app_strings.dart';
import 'package:sistem_manajemen_laundry/core/router/app_router.dart';
import 'package:sistem_manajemen_laundry/core/widgets/empty_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navHome),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: AppStrings.navSettings,
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: const EmptyState(
        icon: Icons.wb_sunny_outlined,
        title: 'Belum ada aktivitas',
        message: AppStrings.homeEmpty,
      ),
    );
  }
}
