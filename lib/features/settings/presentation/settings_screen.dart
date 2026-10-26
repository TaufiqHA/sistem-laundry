import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/router/app_router.dart';
import 'package:sistem_manajemen_laundry/features/settings/domain/app_settings.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: settings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Gagal memuat pengaturan.'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(settingsProvider),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
        data: (settings) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            const _SectionHeader('Usaha'),
            _SettingsCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.storefront_outlined),
                  title: const Text('Profil usaha'),
                  subtitle: Text(
                    settings.hasBusinessName
                        ? settings.businessName
                        : 'Belum diisi',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.businessProfile),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.local_laundry_service_outlined),
                  title: const Text('Layanan & harga'),
                  subtitle: const Text('Daftar layanan dan tarif'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.services),
                ),
              ],
            ),
            const _SectionHeader('Nota dan cetak'),
            _SettingsCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: const Text('Format nomor nota'),
                  subtitle: Text(settings.notaFormat),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      _editNotaFormat(context, ref, settings.notaFormat),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.print_outlined),
                  title: const Text('Ukuran label'),
                  subtitle: Text(
                    AppSettings.labelSizes[settings.labelSize] ??
                        settings.labelSize,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      _chooseLabelSize(context, ref, settings.labelSize),
                ),
              ],
            ),
            const _SectionHeader('Operasional'),
            _SettingsCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.schedule_outlined),
                  title: const Text('Batas cucian belum diambil'),
                  subtitle: Text('${settings.overdueDays} hari'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      _editOverdueDays(context, ref, settings.overdueDays),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editNotaFormat(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final value = await showDialog<String>(
      context: context,
      builder: (_) => _NotaFormatDialog(initial: current),
    );
    if (value == null || !context.mounted) {
      return;
    }
    await _save(
      context,
      ref,
      () => ref.read(settingsRepositoryProvider).setNotaFormat(value),
    );
  }

  Future<void> _editOverdueDays(
    BuildContext context,
    WidgetRef ref,
    int current,
  ) async {
    final value = await showDialog<int>(
      context: context,
      builder: (_) => _OverdueDaysDialog(initial: current),
    );
    if (value == null || !context.mounted) {
      return;
    }
    await _save(
      context,
      ref,
      () => ref.read(settingsRepositoryProvider).setOverdueDays(value),
    );
  }

  Future<void> _chooseLabelSize(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Ukuran label'),
        children: [
          RadioGroup<String>(
            groupValue: current,
            onChanged: (value) => Navigator.of(dialogContext).pop(value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final entry in AppSettings.labelSizes.entries)
                  RadioListTile<String>(
                    value: entry.key,
                    title: Text(entry.value),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    if (value == null || !context.mounted) {
      return;
    }
    await _save(
      context,
      ref,
      () => ref.read(settingsRepositoryProvider).setLabelSize(value),
    );
  }

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() action,
  ) async {
    try {
      await action();
      ref.invalidate(settingsProvider);
    } on Exception {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan pengaturan.')),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          letterSpacing: 0.8,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _NotaFormatDialog extends StatefulWidget {
  const _NotaFormatDialog({required this.initial});

  final String initial;

  @override
  State<_NotaFormatDialog> createState() => _NotaFormatDialogState();
}

class _NotaFormatDialogState extends State<_NotaFormatDialog> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final error = AppSettings.validateNotaFormat(_controller.text);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Format nomor nota'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Format',
              errorText: _error,
              helperText: 'Gunakan {tanggal} dan {urut}',
            ),
            onChanged: (_) {
              if (_error != null) {
                setState(() => _error = null);
              }
            },
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Simpan')),
      ],
    );
  }
}

class _OverdueDaysDialog extends StatefulWidget {
  const _OverdueDaysDialog({required this.initial});

  final int initial;

  @override
  State<_OverdueDaysDialog> createState() => _OverdueDaysDialogState();
}

class _OverdueDaysDialogState extends State<_OverdueDaysDialog> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.initial}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = int.tryParse(_controller.text.trim());
    if (value == null || value < 1 || value > 365) {
      setState(() => _error = 'Isi angka 1 sampai 365');
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Batas cucian belum diambil'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Jumlah hari',
          suffixText: 'hari',
          errorText: _error,
        ),
        onChanged: (_) {
          if (_error != null) {
            setState(() => _error = null);
          }
        },
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Simpan')),
      ],
    );
  }
}
