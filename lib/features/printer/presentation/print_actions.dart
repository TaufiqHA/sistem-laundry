import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/router/app_router.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/printer/data/escpos_builder.dart';
import 'package:sistem_manajemen_laundry/features/printer/domain/print_content.dart';
import 'package:sistem_manajemen_laundry/features/printer/domain/printer_service.dart';
import 'package:sistem_manajemen_laundry/features/printer/presentation/printer_providers.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/settings_providers.dart';

enum PrintTarget { receipt, label, both }

abstract final class PrintActions {
  static Future<void> run(
    BuildContext context,
    WidgetRef ref, {
    required OrderDetail detail,
    required PrintTarget target,
  }) async {
    final settingsRepository = ref.read(settingsRepositoryProvider);
    final printer = await settingsRepository.printer();

    if (!context.mounted) {
      return;
    }
    if (printer == null) {
      await _promptSetup(context);
      return;
    }

    final settings = await settingsRepository.load();
    final paper = settings.paperWidth == 80 ? PaperSize.mm80 : PaperSize.mm58;
    final service = ref.read(printerServiceProvider);

    try {
      if (!await service.isConnected()) {
        final connected = await service.connect(
          PrinterDevice(name: printer.name, address: printer.address),
        );
        if (!connected) {
          throw Exception('Printer tidak tersambung');
        }
      }

      if (target == PrintTarget.receipt || target == PrintTarget.both) {
        final bytes = await EscPosBuilder.receipt(
          ReceiptContent.fromDetail(detail, settings),
          paper: paper,
        );
        await service.write(bytes);
      }
      if (target == PrintTarget.label || target == PrintTarget.both) {
        final bytes = await EscPosBuilder.label(
          LabelContent.fromDetail(detail),
          paper: paper,
          labelSize: settings.labelSize,
        );
        await service.write(bytes);
      }

      if (context.mounted) {
        _show(context, 'Perintah cetak dikirim ke ${printer.name}.');
      }
    } on Exception {
      if (context.mounted) {
        _show(context, 'Gagal mencetak. Periksa printer dan coba lagi.');
      }
    }
  }

  static Future<void> _promptSetup(BuildContext context) async {
    final open = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Printer belum diatur'),
        content: const Text(
          'Sambungkan printer Bluetooth lebih dulu lewat Pengaturan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Atur printer'),
          ),
        ],
      ),
    );
    if (open == true && context.mounted) {
      await context.push(AppRoutes.printerSettings);
    }
  }

  static void _show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
