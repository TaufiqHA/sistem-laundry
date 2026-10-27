import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sistem_manajemen_laundry/core/l10n/app_strings.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/scan_result.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_providers.dart';
import 'package:sistem_manajemen_laundry/features/scan/domain/qr_payload.dart';
import 'package:sistem_manajemen_laundry/features/scan/presentation/scan_result_sheet.dart';

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

  @override
  void initState() {
    super.initState();
    _ensurePermission();
  }

  @override
  void dispose() {
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
    if (_busy || _permissionDenied || capture.barcodes.isEmpty) {
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
    setState(() => _busy = true);
    final advance = await showScanResult(context, result);
    if (!mounted) {
      return;
    }
    setState(() => _busy = false);

    if (advance && result.detail != null) {
      await _advance(result);
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${detail.order.nomorNota} → ${next.label}'),
          action: SnackBarAction(
            label: 'Urungkan',
            onPressed: () async {
              try {
                await ref
                    .read(orderRepositoryProvider)
                    .undoLastStatus(detail.order.id);
                ref.invalidate(orderDetailProvider(detail.order.id));
                ref.invalidate(orderListProvider);
                ref.invalidate(customerOrdersProvider);
                ref.invalidate(homeSummaryProvider);
                ref.invalidate(readyOrdersProvider);
                ref.invalidate(overdueOrdersProvider);
              } on Exception {
                // Perubahan sudah tidak bisa diurungkan.
              }
            },
          ),
        ),
      );
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengubah status. Coba lagi.')),
        );
      }
    } finally {
      _lastHandled = DateTime.now();
    }
  }

  Future<void> _manualLookup() async {
    final controller = TextEditingController();
    final nota = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ketik nomor nota'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(hintText: 'LDR-20261027-001'),
          onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            child: const Text('Cari'),
          ),
        ],
      ),
    );
    controller.dispose();
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
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Column(
                children: [
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
