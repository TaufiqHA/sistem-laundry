import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/widgets/app_shell.dart';
import 'package:sistem_manajemen_laundry/features/customer/presentation/customer_detail_page.dart';
import 'package:sistem_manajemen_laundry/features/customer/presentation/customers_screen.dart';
import 'package:sistem_manajemen_laundry/features/home/presentation/home_screen.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_detail_page.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_form_page.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/orders_screen.dart';
import 'package:sistem_manajemen_laundry/features/report/presentation/reports_screen.dart';
import 'package:sistem_manajemen_laundry/features/scan/presentation/scan_screen.dart';
import 'package:sistem_manajemen_laundry/features/service/presentation/services_screen.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/business_profile_page.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/onboarding_screen.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/settings_screen.dart';

abstract final class AppRoutes {
  static const onboarding = '/onboarding';
  static const home = '/';
  static const orders = '/order';
  static const customers = '/pelanggan';
  static const reports = '/laporan';
  static const settings = '/pengaturan';
  static const businessProfile = '/pengaturan/profil';
  static const services = '/layanan';
  static const scan = '/scan';
  static const orderForm = '/order/baru';

  static String customerDetail(int id) => '/pelanggan/$id';

  static String orderDetail(int id) => '/order/$id';

  static String orderEdit(int id) => '/order/$id/ubah';
}

GoRouter createRouter({String initialLocation = AppRoutes.home}) {
  return GoRouter(
    initialLocation: initialLocation,
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
                path: AppRoutes.scan,
                builder: (context, state) => const ScanScreen(),
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
      // Layar di bawah ini dibuka di atas shell supaya menutupnya
      // mengembalikan pengguna ke tab asal, bukan ke beranda.
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.businessProfile,
        builder: (context, state) => const BusinessProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.services,
        builder: (context, state) => const ServicesScreen(),
      ),
      GoRoute(
        path: '/pelanggan/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return CustomerDetailPage(customerId: id ?? -1);
        },
      ),
      GoRoute(
        path: AppRoutes.orderForm,
        builder: (context, state) => const OrderFormPage(),
      ),
      GoRoute(
        path: '/order/:id/ubah',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return OrderFormPage(orderId: id);
        },
      ),
      GoRoute(
        path: '/order/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return OrderDetailPage(orderId: id ?? -1);
        },
      ),
    ],
  );
}
