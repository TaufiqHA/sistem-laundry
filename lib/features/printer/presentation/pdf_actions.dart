import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/printer/data/pdf_receipt_builder.dart';
import 'package:sistem_manajemen_laundry/features/printer/domain/print_content.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/settings_providers.dart';

abstract final class PdfActions {
  static Future<void> shareReceipt(
    BuildContext context,
    WidgetRef ref,
    OrderDetail detail,
  ) async {
    try {
      final settings = await ref.read(settingsRepositoryProvider).load();
      final bytes = await PdfReceiptBuilder.build(
        ReceiptContent.fromDetail(detail, settings),
      );

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/nota-${detail.order.nomorNota}.pdf');
      await file.writeAsBytes(bytes, flush: true);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'Nota ${detail.order.nomorNota}',
        ),
      );
    } on Exception {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuat nota PDF.')),
        );
      }
    }
  }
}
