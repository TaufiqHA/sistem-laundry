import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/router/app_router.dart';
import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/home_summary.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_providers.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_widgets.dart';
import 'package:sistem_manajemen_laundry/features/settings/domain/app_settings.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/settings_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summary = ref.watch(homeSummaryProvider);
    final ready = ref.watch(readyOrdersProvider);
    final overdue = ref.watch(overdueOrdersProvider);
    final settings = ref.watch(settingsProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Pengaturan',
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(homeSummaryProvider);
          ref.invalidate(readyOrdersProvider);
          ref.invalidate(overdueOrdersProvider);
          await Future<void>.delayed(const Duration(milliseconds: 300));
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Text(
              _greeting(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              settings?.displayName ?? 'Manajemen Laundry',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            _SummaryCard(summary: summary),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.push(AppRoutes.orderForm),
                    icon: const Icon(Icons.add),
                    label: const Text('Order baru'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.push(AppRoutes.scan),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan label'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _BackupBanner(settings: settings),
            const SizedBox(height: 24),
            _SectionHeader(
              title: 'Siap diambil',
              count: summary.value?.readyCount,
              onSeeAll: () => context.go(AppRoutes.orders),
            ),
            const SizedBox(height: 8),
            _OrderSection(
              orders: ready,
              emptyMessage: 'Belum ada cucian yang siap diambil.',
            ),
            if ((summary.value?.overdueCount ?? 0) > 0) ...[
              const SizedBox(height: 24),
              _SectionHeader(
                title: 'Belum diambil > ${settings?.overdueDays ?? 7} hari',
                count: summary.value?.overdueCount,
                onSeeAll: () => context.go(AppRoutes.orders),
              ),
              const SizedBox(height: 8),
              _OrderSection(
                orders: overdue,
                emptyMessage: 'Tidak ada cucian menumpuk.',
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) {
      return 'Selamat pagi';
    }
    if (hour < 15) {
      return 'Selamat siang';
    }
    if (hour < 19) {
      return 'Selamat sore';
    }
    return 'Selamat malam';
  }
}

class _SummaryCard extends ConsumerWidget {
  const _SummaryCard({required this.summary});

  final AsyncValue<HomeSummary> summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: summary.when(
          loading: () => const SizedBox(
            height: 96,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                const Expanded(child: Text('Gagal memuat ringkasan.')),
                TextButton(
                  onPressed: () => ref.invalidate(homeSummaryProvider),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
          data: (summary) => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _Stat(
                      label: 'Order hari ini',
                      value: '${summary.orderCount}',
                    ),
                  ),
                  Expanded(
                    child: _Stat(
                      label: 'Pemasukan',
                      value: Rupiah.format(summary.income),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _Stat(
                      label: 'Piutang baru',
                      value: Rupiah.format(summary.newReceivable),
                      color: summary.newReceivable > 0
                          ? theme.colorScheme.error
                          : null,
                    ),
                  ),
                  Expanded(
                    child: _Stat(
                      label: 'Siap diambil',
                      value: '${summary.readyCount}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _BackupBanner extends StatelessWidget {
  const _BackupBanner({required this.settings});

  final AppSettings? settings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = settings?.backupAgeDays;
    final warning = days == null || days > 7;
    final text = switch (days) {
      null => 'Belum pernah backup',
      0 => 'Backup terakhir hari ini',
      _ => 'Backup terakhir $days hari lalu',
    };

    return Card(
      child: ListTile(
        leading: Icon(
          warning ? Icons.backup_outlined : Icons.cloud_done_outlined,
          color: warning ? theme.colorScheme.error : null,
        ),
        title: Text(text),
        subtitle: const Text(
          'Data hanya ada di perangkat ini sampai backup dibuat.',
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.onSeeAll,
    this.count,
  });

  final String title;
  final int? count;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            count == null ? title : '$title ($count)',
            style: theme.textTheme.titleMedium,
          ),
        ),
        TextButton(onPressed: onSeeAll, child: const Text('Semua order')),
      ],
    );
  }
}

class _OrderSection extends StatelessWidget {
  const _OrderSection({required this.orders, required this.emptyMessage});

  final AsyncValue<List<LaundryOrder>> orders;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return orders.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Gagal memuat daftar order.'),
      ),
      data: (orders) {
        if (orders.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                emptyMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }
        return Column(
          children: [
            for (final order in orders.take(5))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OrderCard(order: order, showCustomer: true),
              ),
          ],
        );
      },
    );
  }
}
