import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/l10n/app_strings.dart';
import 'package:sistem_manajemen_laundry/core/router/app_router.dart';

/// Kerangka navigasi utama. Scan bukan tab, melainkan layar penuh yang
/// dibuka dari item tengah, supaya kamera tidak hidup saat tab lain dibuka.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _destinationIndex(navigationShell.currentIndex),
        onDestinationSelected: (index) =>
            _onDestinationSelected(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: AppStrings.navHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: AppStrings.navOrders,
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: AppStrings.navCustomers,
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner),
            label: AppStrings.scan,
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: AppStrings.navReports,
          ),
        ],
      ),
    );
  }

  /// Cabang 0..2 tampil di indeks yang sama; cabang Laporan (3) ada di
  /// indeks 4 karena indeks 3 dipakai tombol Scan.
  int _destinationIndex(int branch) => branch >= 3 ? 4 : branch;

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == 3) {
      context.push(AppRoutes.scan);
      return;
    }
    final branch = index > 3 ? index - 1 : index;
    navigationShell.goBranch(
      branch,
      initialLocation: branch == navigationShell.currentIndex,
    );
  }
}
