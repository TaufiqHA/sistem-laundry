import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/router/app_router.dart';
import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/core/utils/tanggal.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_status.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({required this.status, super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground) = switch (status) {
      OrderStatus.diterima => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
      OrderStatus.diproses => (
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
      OrderStatus.selesai => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      OrderStatus.diambil => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: foreground, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({required this.order, super.key, this.showCustomer = true});

  final LaundryOrder order;
  final bool showCustomer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.orderDetail(order.id)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.nomorNota,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  StatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: 6),
              if (showCustomer)
                Text(order.customerNama, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      formatTanggalJam(order.tanggalMasuk),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Text(
                    Rupiah.format(order.total),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
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
