import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sistem_manajemen_laundry/features/printer/data/escpos_builder.dart';
import 'package:sistem_manajemen_laundry/features/printer/domain/printer_service.dart';
import 'package:sistem_manajemen_laundry/features/printer/presentation/printer_providers.dart';
import 'package:sistem_manajemen_laundry/features/settings/domain/app_settings.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/settings_providers.dart';

class PrinterSettingsPage extends ConsumerStatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  ConsumerState<PrinterSettingsPage> createState() =>
      _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends ConsumerState<PrinterSettingsPage> {
  List<PrinterDevice> _devices = const [];
  ({String name, String address})? _saved;
  bool _bluetoothOn = false;
  bool _connected = false;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final service = ref.read(printerServiceProvider);
    final repo = ref.read(settingsRepositoryProvider);
    final saved = await repo.printer();
    final bluetoothOn = await service.isBluetoothEnabled();
    final connected = saved == null ? false : await service.isConnected();

    if (!mounted) {
      return;
    }
    setState(() {
      _saved = saved;
      _bluetoothOn = bluetoothOn;
      _connected = connected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Printer')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          if (!_bluetoothOn) ...[
            Card(
              color: theme.colorScheme.errorContainer,
              child: ListTile(
                leading: Icon(
                  Icons.bluetooth_disabled,
                  color: theme.colorScheme.onErrorContainer,
                ),
                title: Text(
                  'Bluetooth tidak aktif',
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
                subtitle: Text(
                  'Nyalakan Bluetooth, lalu tekan Cari printer.',
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          _SavedPrinterCard(
            saved: _saved,
            connected: _connected,
            busy: _busy,
            onConnect: _connectSaved,
            onDisconnect: _disconnect,
            onTest: _testPrint,
          ),
          const SizedBox(height: 24),
          Text('Lebar kertas', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: [
              for (final entry in AppSettings.paperWidths.entries)
                ButtonSegment(value: entry.key, label: Text(entry.value)),
            ],
            selected: {settings.value?.paperWidth ?? 58},
            onSelectionChanged: (selection) => _setPaperWidth(selection.first),
          ),
          const SizedBox(height: 24),
          Text('Cari printer', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Pasangkan printer lewat pengaturan Bluetooth Android, '
            'lalu tekan tombol di bawah.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: _busy ? null : _scan,
            icon: const Icon(Icons.search),
            label: const Text('Cari printer'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 8),
          for (final device in _devices)
            Card(
              child: ListTile(
                leading: const Icon(Icons.print_outlined),
                title: Text(device.name),
                subtitle: Text(device.address),
                trailing: _saved?.address == device.address
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => _connect(device),
              ),
            ),
        ],
      ),
    );
  }

  Future<bool> _ensurePermissions() async {
    if (!Platform.isAndroid) {
      return true;
    }
    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
    final granted = statuses.values.every((status) => status.isGranted);
    if (!granted) {
      setState(() {
        _error = 'Izin Bluetooth ditolak. Aktifkan lewat pengaturan aplikasi.';
      });
    }
    return granted;
  }

  Future<void> _scan() async {
    if (!await _ensurePermissions() || !mounted) {
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final service = ref.read(printerServiceProvider);
      final enabled = await service.isBluetoothEnabled();
      final devices = enabled
          ? await service.pairedDevices()
          : <PrinterDevice>[];
      if (!mounted) {
        return;
      }
      setState(() {
        _bluetoothOn = enabled;
        _devices = devices;
        if (!enabled) {
          _error = 'Bluetooth tidak aktif.';
        } else if (devices.isEmpty) {
          _error = 'Belum ada printer yang dipasangkan dengan HP ini.';
        }
      });
    } on Exception {
      if (mounted) {
        setState(() => _error = 'Gagal membaca daftar printer.');
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _connect(PrinterDevice device) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final service = ref.read(printerServiceProvider);
      final connected = await service.connect(device);
      if (!connected) {
        throw Exception('Koneksi gagal');
      }
      await ref
          .read(settingsRepositoryProvider)
          .setPrinter(name: device.name, address: device.address);
      ref.invalidate(settingsProvider);
      if (!mounted) {
        return;
      }
      setState(() {
        _saved = (name: device.name, address: device.address);
        _connected = true;
      });
      _show('${device.name} tersambung.');
    } on Exception {
      if (mounted) {
        setState(() {
          _connected = false;
          _error = 'Gagal menyambungkan printer.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _connectSaved() async {
    final saved = _saved;
    if (saved == null) {
      return;
    }
    await _connect(PrinterDevice(name: saved.name, address: saved.address));
  }

  Future<void> _disconnect() async {
    try {
      await ref.read(printerServiceProvider).disconnect();
      if (mounted) {
        setState(() => _connected = false);
      }
    } on Exception {
      if (mounted) {
        setState(() => _error = 'Gagal memutuskan printer.');
      }
    }
  }

  Future<void> _testPrint() async {
    setState(() => _busy = true);
    try {
      final service = ref.read(printerServiceProvider);
      final settings = await ref.read(settingsRepositoryProvider).load();
      final bytes = await EscPosBuilder.testPage(
        settings.hasBusinessName ? settings.businessName : 'Laundry',
      );
      final ok = await service.write(bytes);
      if (!ok) {
        throw Exception('Tulis gagal');
      }
      _show('Halaman uji dikirim.');
    } on Exception {
      if (mounted) {
        _show('Gagal mencetak. Periksa koneksi printer.');
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _setPaperWidth(int width) async {
    await ref.read(settingsRepositoryProvider).setPaperWidth(width);
    ref.invalidate(settingsProvider);
  }

  void _show(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SavedPrinterCard extends StatelessWidget {
  const _SavedPrinterCard({
    required this.saved,
    required this.connected,
    required this.busy,
    required this.onConnect,
    required this.onDisconnect,
    required this.onTest,
  });

  final ({String name, String address})? saved;
  final bool connected;
  final bool busy;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;
  final VoidCallback onTest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final printer = saved;

    if (printer == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Belum ada printer tersimpan. Cari dan sambungkan printer di bawah.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    final status = connected ? 'Terhubung' : 'Belum terhubung';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.print_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(printer.name, style: theme.textTheme.titleMedium),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: connected
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(status, style: theme.textTheme.labelSmall),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              printer.address,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: connected
                      ? OutlinedButton(
                          onPressed: busy ? null : onDisconnect,
                          child: const Text('Putuskan'),
                        )
                      : FilledButton(
                          onPressed: busy ? null : onConnect,
                          child: const Text('Sambungkan'),
                        ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: busy ? null : onTest,
                    icon: const Icon(Icons.receipt_long_outlined),
                    label: const Text('Cetak uji'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
