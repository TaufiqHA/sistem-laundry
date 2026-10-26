import 'package:flutter/material.dart';

import 'package:sistem_manajemen_laundry/core/l10n/app_strings.dart';

/// Keadaan kosong yang seragam di semua layar. Setiap layar wajib punya
/// satu supaya pengguna baru tidak melihat halaman putih.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 56,
              color: theme.colorScheme.primary,
              semanticLabel: title,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}

/// Penanda sementara untuk layar yang belum dikerjakan pada fase ini.
class ComingSoon extends StatelessWidget {
  const ComingSoon({required this.title, required this.message, super.key});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.construction_outlined,
      title: title,
      message: message,
      action: const Chip(
        label: Text(AppStrings.comingSoon),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
