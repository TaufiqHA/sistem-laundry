import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/widgets/app_shell.dart';
import 'package:sistem_manajemen_laundry/features/customer/presentation/customers_screen.dart';
import 'package:sistem_manajemen_laundry/features/home/presentation/home_screen.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/orders_screen.dart';
import 'package:sistem_manajemen_laundry/features/report/presentation/reports_screen.dart';
import 'package:sistem_manajemen_laundry/features/scan/presentation/scan_screen.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/settings_screen.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const orders = '/order';
  static const customers = '/pelanggan';
  static const reports = '/laporan';
  static const settings = '/pengaturan';
  static const scan = '/scan';
}

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orders,
                builder: (context, state) => const OrdersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.customers,
                builder: (context, state) => const CustomersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.reports,
                builder: (context, state) => const ReportsScreen(),
              ),
            ],
          ),
        ],
      ),
      // Scan dan pengaturan dibuka di atas shell supaya menutupnya
      // mengembalikan pengguna ke tab asal, bukan ke beranda.
      GoRoute(
        path: AppRoutes.scan,
        builder: (context, state) => const ScanScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
