import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/core/utils/tanggal.dart';
import 'package:sistem_manajemen_laundry/features/backup/domain/backup_archive.dart';
import 'package:sistem_manajemen_laundry/features/backup/presentation/backup_providers.dart';
import 'package:sistem_manajemen_laundry/features/settings/data/settings_repository.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/settings_providers.dart';

class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider).value;
    final age = settings?.backupAgeDays;

    return Scaffold(
      appBar: AppBar(title: const Text('Backup & restore')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        age == null || age > 7
                            ? Icons.warning_amber_outlined
                            : Icons.cloud_done_outlined,
                        color: age == null || age > 7
                            ? theme.colorScheme.error
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(switch (age) {
                          null => 'Belum pernah backup',
                          0 => 'Backup terakhir hari ini',
                          _ => 'Backup terakhir $age hari lalu',
                        }, style: theme.textTheme.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Backup berisi seluruh data usaha dalam satu file. '
                    'Simpan di tempat lain, misalnya Google Drive.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _busy ? null : _createBackup,
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.backup_outlined),
            label: const Text('Buat backup sekarang'),
          ),
          const SizedBox(height: 8),
          Text(
            'File disimpan di folder aplikasi, lalu dibagikan lewat menu '
            'bagikan agar bisa dipindah ke Drive atau komputer.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Text('Pulihkan', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _busy ? null : _pickAndRestore,
            icon: const Icon(Icons.restore),
            label: const Text('Pulihkan dari file'),
          ),
          const SizedBox(height: 8),
          Text(
            'Data saat ini akan diganti. Aplikasi membuat backup otomatis '
            'sebelum memulihkan.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Text('Backup di perangkat', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          _LocalBackups(onRestore: _restoreLocal),
          const SizedBox(height: 24),
          Card(
            color: theme.colorScheme.surfaceContainerHighest,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Backup terakhir yang disimpan di folder aplikasi: '
                '5 file terbaru. File lama otomatis dihapus.',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createBackup() async {
    setState(() => _busy = true);
    try {
      final file = await _writeBackup();
      await ref
          .read(settingsRepositoryProvider)
          .setDateTime(SettingKeys.lastBackupAt, DateTime.now());
      ref.invalidate(settingsProvider);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'Backup Laundry',
          text: 'Backup data laundry ${formatTanggal(DateTime.now())}',
        ),
      );

      if (mounted) {
        _show('Backup dibuat: ${file.uri.pathSegments.last}');
      }
      ref.invalidate(localBackupsProvider);
    } on Exception {
      if (mounted) {
        _show('Gagal membuat backup. Coba lagi.');
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<File> _writeBackup() async {
    final db = ref.read(databaseProvider);
    final orderRow = await db
        .customSelect('SELECT COUNT(*) AS n FROM orders')
        .getSingle();
    final customerRow = await db
        .customSelect('SELECT COUNT(*) AS n FROM customers')
        .getSingle();

    return ref
        .read(backupServiceProvider)
        .createBackupFile(
          schemaVersion: db.schemaVersion,
          orderCount: orderRow.read<int>('n'),
          customerCount: customerRow.read<int>('n'),
        );
  }

  Future<void> _pickAndRestore() async {
    final files = await FilePicker.pickFiles(dialogTitle: 'Pilih file backup');
    if (files.isEmpty || !mounted) {
      return;
    }

    final db = ref.read(databaseProvider);
    final BackupPayload payload;
    try {
      final bytes = await files.first.readAsBytes();
      payload = BackupArchive.parse(
        bytes,
        currentSchemaVersion: db.schemaVersion,
      );
    } on BackupException catch (error) {
      if (mounted) {
        _show(error.message);
      }
      return;
    }

    if (!mounted) {
      return;
    }
    await _confirmAndRestore(payload);
  }

  Future<void> _restoreLocal(File file) async {
    final db = ref.read(databaseProvider);
    try {
      final payload = BackupArchive.parse(
        await file.readAsBytes(),
        currentSchemaVersion: db.schemaVersion,
      );
      await _confirmAndRestore(payload);
    } on BackupException catch (error) {
      if (mounted) {
        _show(error.message);
      }
    } on Exception {
      if (mounted) {
        _show('File backup tidak bisa dibaca.');
      }
    }
  }

  Future<void> _confirmAndRestore(BackupPayload payload) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pulihkan data?'),
        content: Text(
          'Backup dari ${formatTanggalJam(payload.metadata.createdAt)} berisi '
          '${payload.metadata.orderCount} order dan '
          '${payload.metadata.customerCount} pelanggan.\n\n'
          'Data saat ini akan diganti. Backup otomatis dibuat lebih dulu.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Pulihkan'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    await _restore(payload);
  }

  Future<void> _restore(BackupPayload payload) async {
    setState(() => _busy = true);
    var databaseClosed = false;

    try {
      await _writeBackup();
      await ref
          .read(backupServiceProvider)
          .writeRestoredDatabase(payload.database);
      databaseClosed = true;
    } on Exception {
      if (mounted) {
        _show('Gagal memulihkan data. Backup otomatis tetap tersimpan.');
        if (!databaseClosed) {
          setState(() => _busy = false);
        }
      }
      return;
    }

    if (!mounted) {
      return;
    }
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Data dipulihkan'),
          content: const Text(
            'Tutup aplikasi lalu buka lagi agar data hasil restore dimuat.',
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                SystemNavigator.pop();
              },
              child: const Text('Tutup aplikasi'),
            ),
          ],
        ),
      ),
    );
  }

  void _show(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _LocalBackups extends ConsumerWidget {
  const _LocalBackups({required this.onRestore});

  final ValueChanged<File> onRestore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backups = ref.watch(localBackupsProvider);
    final theme = Theme.of(context);

    return backups.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Gagal membaca daftar backup.'),
        ),
      ),
      data: (files) {
        if (files.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Belum ada backup di perangkat.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }
        return Card(
          child: Column(
            children: [
              for (var index = 0; index < files.length; index++) ...[
                if (index > 0) const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.archive_outlined),
                  title: Text(
                    files[index].uri.pathSegments.last,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${(files[index].lengthSync() / 1024).ceil()} KB',
                  ),
                  trailing: TextButton(
                    onPressed: () => onRestore(files[index]),
                    child: const Text('Pulihkan'),
                  ),
                  onTap: () => onRestore(files[index]),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
