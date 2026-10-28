import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:sistem_manajemen_laundry/core/utils/quantity.dart';
import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/core/utils/tanggal.dart';
import 'package:sistem_manajemen_laundry/features/printer/domain/print_content.dart';

/// Nota PDF untuk dibagikan lewat WhatsApp atau aplikasi lain saat
/// printer tidak tersedia.
abstract final class PdfReceiptBuilder {
  static Future<Uint8List> build(ReceiptContent content) async {
    final document = pw.Document();
    const small = pw.TextStyle(fontSize: 9, color: PdfColors.grey700);

    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  content.businessName,
                  style: const pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              if (content.address.isNotEmpty)
                pw.Center(child: pw.Text(content.address, style: small)),
              if (content.phone.isNotEmpty)
                pw.Center(child: pw.Text(content.phone, style: small)),
              pw.SizedBox(height: 8),
              pw.Divider(),
              pw.Text(
                'No. ${content.nota}',
                style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              if (content.masuk != null)
                pw.Text(formatTanggalJam(content.masuk!)),
              pw.Text('Pelanggan: ${content.customerName}'),
              pw.Divider(),
              for (final item in content.items) ...[
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(child: pw.Text(item.nama)),
                    pw.Text(Rupiah.format(item.subtotal)),
                  ],
                ),
                pw.Text(
                  '${Quantity.format(item.qtyMilli, unit: item.satuan)} x '
                  '${Rupiah.format(item.hargaSatuan)}',
                  style: small,
                ),
                pw.SizedBox(height: 4),
              ],
              pw.Divider(),
              _row('Subtotal', Rupiah.format(content.subtotal)),
              if (content.diskon > 0)
                _row('Diskon', '-${Rupiah.format(content.diskon)}'),
              _row('Total', Rupiah.format(content.total), bold: true),
              _row('Dibayar', Rupiah.format(content.dibayar)),
              if (content.piutang > 0)
                _row('Sisa', Rupiah.format(content.piutang), bold: true),
              pw.SizedBox(height: 12),
              if (content.footer.isNotEmpty)
                pw.Center(child: pw.Text(content.footer, style: small)),
              pw.Center(child: pw.Text('Terima kasih')),
            ],
          );
        },
      ),
    );

    return document.save();
  }

  static pw.Widget _row(String label, String value, {bool bold = false}) {
    final style = bold
        ? const pw.TextStyle(fontWeight: pw.FontWeight.bold)
        : const pw.TextStyle();
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: style),
          pw.Text(value, style: style),
        ],
      ),
    );
  }
}
