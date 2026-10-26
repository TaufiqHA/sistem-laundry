import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/utils/phone_number.dart';
import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/features/customer/domain/customer.dart';
import 'package:sistem_manajemen_laundry/features/customer/presentation/customer_form_sheet.dart';
import 'package:sistem_manajemen_laundry/features/customer/presentation/customer_providers.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_providers.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_widgets.dart';

class CustomerDetailPage extends ConsumerWidget {
  const CustomerDetailPage({required this.customerId, super.key});

  final int customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerDetailProvider(customerId));
    final current = customer.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelanggan'),
        actions: [
          if (current != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Ubah pelanggan',
              onPressed: () => _edit(context, ref, current),
            ),
        ],
      ),
      body: customer.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            const Center(child: Text('Gagal memuat pelanggan.')),
        data: (customer) {
          if (customer == null) {
            return const Center(child: Text('Pelanggan tidak ditemukan.'));
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              _IdentityCard(customer: customer),
              const SizedBox(height: 24),
              Text('Ringkasan', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _SummaryCard(customerId: customerId),
              const SizedBox(height: 24),
              Text(
                'Riwayat order',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _OrderHistory(customerId: customerId),
            ],
          );
        },
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    Customer customer,
  ) async {
    final savedId = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => CustomerFormSheet(customer: customer),
    );
    if (savedId != null) {
      ref.invalidate(customerDetailProvider(customerId));
      ref.invalidate(customerSummaryProvider(customerId));
      ref.invalidate(customerSearchProvider);
    }
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alamat = customer.alamat;
    final catatan = customer.catatan;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  foregroundColor: theme.colorScheme.onSecondaryContainer,
                  child: Text(
                    customer.initial,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customer.nama, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text(
                        PhoneNumber.display(customer.telepon),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (alamat != null || catatan != null) ...[
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              if (alamat != null)
                _DetailRow(icon: Icons.place_outlined, text: alamat),
              if (catatan != null)
                _DetailRow(icon: Icons.notes_outlined, text: catatan),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _SummaryCard extends ConsumerWidget {
  const _SummaryCard({required this.customerId});

  final int customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(customerSummaryProvider(customerId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: summary.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Gagal memuat ringkasan.'),
          ),
          data: (summary) => Column(
            children: [
              _SummaryRow(
                label: 'Jumlah order',
                value: '${summary.orderCount}',
              ),
              _SummaryRow(
                label: 'Total belanja',
                value: Rupiah.format(summary.totalBelanja),
              ),
              _SummaryRow(
                label: 'Piutang',
                value: Rupiah.format(summary.piutang),
                valueColor: summary.piutang > 0
                    ? Theme.of(context).colorScheme.error
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderHistory extends ConsumerWidget {
  const _OrderHistory({required this.customerId});

  final int customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(customerOrdersProvider(customerId));

    return orders.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => const Card(
        child: ListTile(
          leading: Icon(Icons.history),
          title: Text('Gagal memuat riwayat order.'),
        ),
      ),
      data: (orders) {
        if (orders.isEmpty) {
          return const Card(
            child: ListTile(
              leading: Icon(Icons.history),
              title: Text('Belum ada order'),
              subtitle: Text('Order pelanggan ini akan muncul di sini.'),
            ),
          );
        }
        return Column(
          children: [
            for (final order in orders)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OrderCard(order: order, showCustomer: false),
              ),
          ],
        );
      },
    );
  }
}
