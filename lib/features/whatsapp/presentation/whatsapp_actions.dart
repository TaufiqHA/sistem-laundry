import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sistem_manajemen_laundry/features/whatsapp/domain/whatsapp_message.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class WhatsAppActions {
  /// Membuka WhatsApp. Kalau tidak tersedia, pesan disalin ke papan klip
  /// agar kasir tetap bisa mengirim manual.
  static Future<void> send(
    BuildContext context, {
    required String phone,
    required String message,
  }) async {
    final uri = WhatsAppLink.build(phone, message);
    if (uri == null) {
      _show(context, 'Nomor telepon pelanggan tidak valid.');
      return;
    }

    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      opened = false;
    }

    if (!opened && context.mounted) {
      await Clipboard.setData(ClipboardData(text: message));
      if (context.mounted) {
        _show(
          context,
          'WhatsApp tidak tersedia. Pesan sudah disalin, tempel di WhatsApp.',
        );
      }
    }
  }

  static void _show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
