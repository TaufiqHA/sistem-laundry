import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sistem_manajemen_laundry/core/l10n/app_strings.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/scan_result.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_providers.dart';
import 'package:sistem_manajemen_laundry/features/scan/domain/qr_payload.dart';
import 'package:sistem_manajemen_laundry/features/scan/presentation/scan_result_panel.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool _permissionDenied = false;
  bool _busy = false;
  bool _torchOn = false;
  String? _lastCode;
  DateTime _lastHandled = DateTime.fromMillisecondsSinceEpoch(0);
  ({int orderId, String nota, String nextLabel})? _lastChange;
  Timer? _bannerTimer;
  String? _error;
  ScanResult? _result;

  @override
  void initState() {
    super.initState();
    _ensurePermission();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _ensurePermission() async {
    final status = await Permission.camera.request();
    if (!status.isGranted && mounted) {
      setState(() => _permissionDenied = true);
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_busy ||
        _permissionDenied ||
        _result != null ||
        capture.barcodes.isEmpty) {
      return;
    }
    final code = capture.barcodes.first.rawValue;
    if (code == null || code.isEmpty) {
      return;
    }

    // Abaikan label yang sama dalam 3 detik agar satu label tidak
    // memajukan dua tahap.
    final now = DateTime.now();
    if (code == _lastCode &&
        now.difference(_lastHandled) < const Duration(seconds: 3)) {
      return;
    }
    _lastCode = code;
    _lastHandled = now;

    final payload = QrPayload.parse(code);
    if (payload == null) {
      await _present(const ScanResult(ScanOutcome.tidakValid));
      return;
    }

    try {
      final result = await ref
          .read(orderRepositoryProvider)
          .lookupByToken(payload.token);
      await _present(result);
    } on Exception {
      await _present(const ScanResult(ScanOutcome.tidakDikenal));
    }
  }

  Future<void> _present(ScanResult result) async {
    if (!mounted) {
      return;
    }
    setState(() {
      _busy = false;
      _result = result;
    });
  }

  Future<void> _advance(ScanResult result) async {
    final detail = result.detail!;
    final next = detail.order.status.next;
    if (next == null) {
      return;
    }
    try {
      await ref.read(orderRepositoryProvider).advanceStatus(detail.order.id);
      ref.invalidate(orderDetailProvider(detail.order.id));
      ref.invalidate(orderListProvider);
      ref.invalidate(customerOrdersProvider);
      ref.invalidate(homeSummaryProvider);
      ref.invalidate(readyOrdersProvider);
      ref.invalidate(overdueOrdersProvider);
      if (!mounted) {
        return;
      }
      setState(() {
        _error = null;
        _result = null;
        _lastChange = (
          orderId: detail.order.id,
          nota: detail.order.nomorNota,
          nextLabel: next.label,
        );
      });
      _bannerTimer?.cancel();
      _bannerTimer = Timer(const Duration(seconds: 8), () {
        if (mounted) {
          setState(() => _lastChange = null);
        }
      });
    } on Exception {
      if (mounted) {
        setState(() {
          _result = null;
          _error = 'Gagal mengubah status. Coba lagi.';
        });
      }
    } finally {
      _lastHandled = DateTime.now();
    }
  }

  Future<void> _undoLastChange() async {
    final change = _lastChange;
    if (change == null) {
      return;
    }
    try {
      await ref.read(orderRepositoryProvider).undoLastStatus(change.orderId);
      ref.invalidate(orderDetailProvider(change.orderId));
      ref.invalidate(orderListProvider);
      ref.invalidate(customerOrdersProvider);
      ref.invalidate(homeSummaryProvider);
      ref.invalidate(readyOrdersProvider);
      ref.invalidate(overdueOrdersProvider);
      if (mounted) {
        setState(() => _lastChange = null);
      }
    } on OrderException catch (error) {
      if (mounted) {
        setState(() {
          _lastChange = null;
          _error = error.message;
        });
      }
    }
  }

  Future<void> _manualLookup() async {
    final nota = await showDialog<String>(
      context: context,
      builder: (_) => const _NotaInputDialog(),
    );
    if (nota == null || nota.trim().isEmpty || !mounted) {
      return;
    }

    final result = await ref.read(orderRepositoryProvider).lookupByNota(nota);
    await _present(result);
  }

  Future<void> _toggleTorch() async {
    await _controller.toggleTorch();
    if (mounted) {
      setState(() => _torchOn = !_torchOn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.scan),
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Tutup',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_permissionDenied)
            const _PermissionMessage(onOpenSettings: openAppSettings)
          else
            MobileScanner(controller: _controller, onDetect: _onDetect),
          if (!_permissionDenied) ...[
            IgnorePointer(
              child: Center(
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: IconButton.filledTonal(
                onPressed: _toggleTorch,
                icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off),
                tooltip: 'Senter',
              ),
            ),
            if (_result == null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 24,
                child: Column(
                  children: [
                    if (_lastChange != null) ...[
                      _UndoBanner(
                        nota: _lastChange!.nota,
                        nextLabel: _lastChange!.nextLabel,
                        onUndo: _undoLastChange,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Text(
                      'Arahkan kamera ke QR pada label kantong.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        shadows: const [
                          Shadow(blurRadius: 4, color: Colors.black54),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonalIcon(
                      onPressed: _manualLookup,
                      icon: const Icon(Icons.keyboard),
                      label: const Text('Ketik nomor nota'),
                    ),
                  ],
                ),
              ),
          ],
          if (_result != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ScanResultPanel(
                result: _result!,
                onAdvance: () => _advance(_result!),
                onClose: () => setState(() => _result = null),
              ),
            ),
          if (_busy)
            const ColoredBox(
              color: Colors.black38,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _PermissionMessage extends StatelessWidget {
  const _PermissionMessage({required this.onOpenSettings});

  final Future<bool> Function() onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.no_photography_outlined, size: 56),
            const SizedBox(height: 16),
            Text(
              'Izin kamera diperlukan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Aktifkan izin kamera untuk memindai label, '
              'atau gunakan nomor nota.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onOpenSettings,
              child: const Text('Buka pengaturan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _UndoBanner extends StatelessWidget {
  const _UndoBanner({
    required this.nota,
    required this.nextLabel,
    required this.onUndo,
  });

  final String nota;
  final String nextLabel;
  final VoidCallback onUndo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$nota → $nextLabel',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          TextButton(onPressed: onUndo, child: const Text('Urungkan')),
        ],
      ),
    );
  }
}

class _NotaInputDialog extends StatefulWidget {
  const _NotaInputDialog();

  @override
  State<_NotaInputDialog> createState() => _NotaInputDialogState();
}

class _NotaInputDialogState extends State<_NotaInputDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ketik nomor nota'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.characters,
        decoration: const InputDecoration(hintText: 'LDR-20261027-001'),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Cari'),
        ),
      ],
    );
  }
}
