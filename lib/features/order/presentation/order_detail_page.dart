import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/router/app_router.dart';
import 'package:sistem_manajemen_laundry/core/utils/phone_number.dart';
import 'package:sistem_manajemen_laundry/core/utils/quantity.dart';
import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/core/utils/tanggal.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_providers.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_widgets.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/payment_providers.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/payment_sheet.dart';

class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({required this.orderId, super.key});

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(orderDetailProvider(orderId));
    final current = detail.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail order'),
        actions: [
          if (current != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _edit(context, ref);
                } else {
                  _cancel(context, ref, current);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Ubah order')),
                PopupMenuItem(value: 'cancel', child: Text('Batalkan order')),
              ],
            ),
        ],
      ),
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            const Center(child: Text('Gagal memuat order.')),
        data: (detail) {
          if (detail == null) {
            return const Center(child: Text('Order tidak ditemukan.'));
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              _HeaderCard(order: detail.order),
              const SizedBox(height: 16),
              _CustomerCard(
                order: detail.order,
                onTap: () => context.push(
                  AppRoutes.customerDetail(detail.order.customerId),
                ),
              ),
              const SizedBox(height: 24),
              Text('Layanan', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _ItemsCard(items: detail.items),
              const SizedBox(height: 24),
              Text(
                'Pembayaran',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _PaymentSection(detail: detail),
              const SizedBox(height: 24),
              Text(
                'Riwayat status',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _HistoryCard(history: detail.history),
            ],
          );
        },
      ),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final changed = await context.push<bool>(AppRoutes.orderEdit(orderId));
    if (changed ?? false) {
      ref.invalidate(orderDetailProvider(orderId));
      ref.invalidate(orderListProvider);
      ref.invalidate(customerOrdersProvider);
    }
  }

  Future<void> _cancel(
    BuildContext context,
    WidgetRef ref,
    OrderDetail detail,
  ) async {
    if (!detail.bisaDibatalkan) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Order sudah menerima pembayaran. Hapus pembayaran dulu.',
          ),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Batalkan order?'),
        content: Text(
          'Order ${detail.order.nomorNota} akan dihapus dari daftar. '
          'Nomor nota tidak dipakai ulang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Kembali'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Batalkan'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      await ref.read(orderRepositoryProvider).cancel(orderId);
      ref.invalidate(orderListProvider);
      ref.invalidate(customerOrdersProvider);
      if (context.mounted) {
        context.pop();
      }
    } on OrderException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.order});

  final LaundryOrder order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.nomorNota,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                StatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.login,
              label: 'Masuk',
              value: formatTanggalJam(order.tanggalMasuk),
            ),
            _InfoRow(
              icon: Icons.event_available,
              label: 'Estimasi selesai',
              value: order.estimasiSelesai == null
                  ? 'Belum ditentukan'
                  : formatTanggalJam(order.estimasiSelesai!),
            ),
            if (order.catatan != null)
              _InfoRow(
                icon: Icons.notes_outlined,
                label: 'Catatan',
                value: order.catatan!,
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.order, required this.onTap});

  final LaundryOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.person_outline),
        title: Text(order.customerNama),
        subtitle: Text(PhoneNumber.display(order.customerTelepon)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({required this.items});

  final List<OrderLine> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            for (final item in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.namaLayanan,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${Quantity.format(item.qtyMilli, unit: item.satuan?.label)} × '
                            '${Rupiah.format(item.hargaSatuan)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(Rupiah.format(item.subtotal)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PaymentSection extends ConsumerWidget {
  const _PaymentSection({required this.detail});

  final OrderDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final payments = ref.watch(paymentsProvider(detail.order.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (detail.order.diskon > 0) ...[
                  _row(
                    theme,
                    'Diskon',
                    '- ${Rupiah.format(detail.order.diskon)}',
                  ),
                  const SizedBox(height: 8),
                ],
                _row(
                  theme,
                  'Total',
                  Rupiah.format(detail.order.total),
                  bold: true,
                ),
                const SizedBox(height: 8),
                _row(theme, 'Dibayar', Rupiah.format(detail.dibayar)),
                const SizedBox(height: 8),
                _row(
                  theme,
                  'Piutang',
                  Rupiah.format(detail.piutang),
                  color: detail.piutang > 0 ? theme.colorScheme.error : null,
                ),
                if (detail.piutang > 0) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      onPressed: () => _addPayment(context, ref),
                      icon: const Icon(Icons.payments_outlined),
                      label: const Text('Catat pembayaran'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        payments.when(
          loading: () =>
              const Card(child: ListTile(title: Text('Memuat pembayaran...'))),
          error: (error, stack) => const Card(
            child: ListTile(title: Text('Gagal memuat pembayaran.')),
          ),
          data: (payments) {
            if (payments.isEmpty) {
              return const Card(
                child: ListTile(
                  leading: Icon(Icons.payments_outlined),
                  title: Text('Belum ada pembayaran'),
                  subtitle: Text(
                    'Pembayaran tunai atau cicilan akan tampil di sini.',
                  ),
                ),
              );
            }
            return Card(
              child: Column(
                children: [
                  for (var index = 0; index < payments.length; index++) ...[
                    if (index > 0) const Divider(height: 1),
                    _PaymentRow(
                      payment: payments[index],
                      onDelete: () =>
                          _deletePayment(context, ref, payments[index]),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _addPayment(BuildContext context, WidgetRef ref) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => PaymentSheet(order: detail.order, sisa: detail.piutang),
    );
    if (saved == true) {
      ref.invalidatePaymentViews(
        orderId: detail.order.id,
        customerId: detail.order.customerId,
      );
    }
  }

  Future<void> _deletePayment(
    BuildContext context,
    WidgetRef ref,
    Payment payment,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus pembayaran?'),
        content: Text(
          'Pembayaran ${Rupiah.format(payment.jumlah)} akan dihapus dan '
          'piutang order ini bertambah kembali.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      await ref.read(paymentRepositoryProvider).softDelete(payment.id);
      ref.invalidatePaymentViews(
        orderId: detail.order.id,
        customerId: detail.order.customerId,
      );
    } on PaymentException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }

  Widget _row(
    ThemeData theme,
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    final style = bold
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
        : theme.textTheme.bodyMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style?.copyWith(color: color)),
      ],
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.payment, required this.onDelete});

  final Payment payment;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.payments_outlined),
      title: Text(Rupiah.format(payment.jumlah)),
      subtitle: Text(
        '${payment.metode.label} · ${formatTanggalJam(payment.tanggal)}',
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        tooltip: 'Hapus pembayaran',
        onPressed: onDelete,
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.history});

  final List<StatusChange> history;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (final entry in history)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.statusLama == null
                            ? 'Order dibuat · ${entry.statusBaru.label}'
                            : '${entry.statusLama!.label} → '
                                  '${entry.statusBaru.label}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      formatTanggalJam(entry.waktu),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
