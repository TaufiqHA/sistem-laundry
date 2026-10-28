import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/features/printer/data/pdf_receipt_builder.dart';
import 'package:sistem_manajemen_laundry/features/printer/domain/print_content.dart';

void main() {
  const content = ReceiptContent(
    businessName: 'Laundry Bersih',
    address: 'Jalan Melati 3',
    phone: '081234567890',
    footer: 'Terima kasih',
    nota: 'LDR-20261028-001',
    customerName: 'Ibu Sari',
    masuk: null,
    items: [
      ReceiptItem(
        nama: 'Cuci Kering',
        qtyMilli: 2500,
        satuan: 'kg',
        hargaSatuan: 9000,
        subtotal: 22500,
      ),
    ],
    subtotal: 22500,
    diskon: 0,
    total: 22500,
    dibayar: 10000,
  );

  test('nota PDF terbentuk dengan header PDF', () async {
    final bytes = await PdfReceiptBuilder.build(content);
    final header = latin1.decode(bytes.take(5).toList());

    expect(header, '%PDF-');
    expect(bytes.length, greaterThan(1000));
  });
}
