import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/l10n/app_strings.dart';
import 'package:sistem_manajemen_laundry/core/router/app_router.dart';

/// Kerangka navigasi utama: empat tab di bawah, tombol Scan mengambang.
/// Pengaturan dibuka dari ikon di Beranda supaya label tab tidak berdesakan
/// di layar 360 dp.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.scan),
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text(AppStrings.scan),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
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
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: AppStrings.navReports,
          ),
        ],
      ),
    );
  }

  void _onDestinationSelected(int index) {
    // Menekan tab yang sedang aktif mengembalikan ke halaman awal tab itu.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
