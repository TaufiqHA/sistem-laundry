import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/core/widgets/empty_state.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/laundry_service.dart';
import 'package:sistem_manajemen_laundry/features/service/presentation/service_form_sheet.dart';
import 'package:sistem_manajemen_laundry/features/service/presentation/service_providers.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(serviceListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Layanan & harga')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'service-add-fab',
        onPressed: () => _openForm(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: services.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Gagal memuat layanan.'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(serviceListProvider),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
        data: (services) {
          if (services.isEmpty) {
            return EmptyState(
              icon: Icons.local_laundry_service_outlined,
              title: 'Belum ada layanan',
              message: 'Tambahkan layanan dan tarif agar bisa dipilih saat membuat order.',
              action: FilledButton.icon(
                onPressed: () => _openForm(context, ref, null),
                icon: const Icon(Icons.add),
                label: const Text('Tambah layanan'),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            itemCount: services.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final service = services[index];
              return _ServiceTile(
                service: service,
                onTap: () => _openForm(context, ref, service),
                onActiveChanged: (active) =>
                    _setActive(context, ref, service, active),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref,
    LaundryService? service,
  ) async {
    final saved = await showModalBottomSheet<LaundryService>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => ServiceFormSheet(service: service),
    );
    if (saved != null) {
      ref.invalidate(serviceListProvider);
    }
  }

  Future<void> _setActive(
    BuildContext context,
    WidgetRef ref,
    LaundryService service,
    bool active,
  ) async {
    try {
      await ref
          .read(serviceRepositoryProvider)
          .setActive(service.id, aktif: active);
      ref.invalidate(serviceListProvider);
    } on Exception {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengubah status layanan.')),
        );
      }
    }
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.service,
    required this.onTap,
    required this.onActiveChanged,
  });

  final LaundryService service;
  final VoidCallback onTap;
  final ValueChanged<bool> onActiveChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          service.nama,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: service.aktif
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        subtitle: Text(
          [
            if (service.kategori != null) service.kategori!,
            '${Rupiah.format(service.harga)} / ${service.satuan.label}'
                '${service.aktif ? '' : ' · Nonaktif'}',
          ].join(' · '),
        ),
        trailing: Switch(value: service.aktif, onChanged: onActiveChanged),
      ),
    );
  }
}
