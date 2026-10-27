import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:sistem_manajemen_laundry/features/order/domain/scan_result.dart';

/// Lembar hasil setelah QR terbaca. Hanya mengembalikan `true` kalau
/// kasir menekan tombol ubah status.
class ScanResultSheet extends StatelessWidget {
  const ScanResultSheet({required this.result, super.key});

  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detail = result.detail;
    final order = detail?.order;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (order != null) ...[
              Text(
                order.nomorNota,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(order.customerNama, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 12),
              if (result.bisaDimajukan) ...[
                Text(
                  'Status sekarang: ${order.status.label}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.arrow_forward),
                  label: Text('Ubah ke ${order.status.next!.label}'),
                ),
              ] else if (result.outcome == ScanOutcome.sudahDiambil) ...[
                Text(
                  'Cucian sudah diambil'
                  '${detail!.history.isEmpty ? '' : ' pada ${_tanggalJam(detail.history.last.waktu)}'}.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ] else
              Text(result.outcome.label, style: theme.textTheme.titleMedium),
            if (order == null && result.outcome == ScanOutcome.tidakValid)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Label ini bukan buatan aplikasi ini. '
                  'Periksa label atau cari lewat nomor nota.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            if (order == null && result.outcome == ScanOutcome.tidakDikenal)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Token tidak cocok dengan order mana pun di perangkat ini.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            if (order == null && result.outcome == ScanOutcome.dibatalkan)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Order ini sudah dibatalkan dan tidak bisa diproses.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }

  static String _tanggalJam(DateTime value) {
    final local = value.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.day}/${local.month}/${local.year} $hour:$minute';
  }
}

/// Menampilkan lembar hasil apa pun (valid, tidak dikenal, atau batal).
Future<bool> showScanResult(BuildContext context, ScanResult result) async {
  final action = await showModalBottomSheet<bool>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => ScanResultSheet(result: result),
  );
  return action ?? false;
}

/// Apakah error berasal dari izin kamera yang ditolak.
bool isPermissionError(MobileScannerException error) {
  return error.errorCode == MobileScannerErrorCode.permissionDenied;
}
