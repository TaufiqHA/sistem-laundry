import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/features/printer/data/escpos_builder.dart';
import 'package:sistem_manajemen_laundry/features/printer/domain/print_content.dart';

/// CapabilityProfile memuat aset dari bundle, jadi binding harus siap.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const receipt = ReceiptContent(
    businessName: 'Laundry Bersih',
    address: 'Jalan Melati 3',
    phone: '081234567890',
    footer: 'Cucian diambil maksimal 7 hari',
    nota: 'LDR-20261027-001',
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

  const label = LabelContent(
    nota: 'LDR-20261027-001',
    customerName: 'Ibu Sari',
    itemLines: ['Cuci Kering · 2,5 kg'],
    qrPayload: 'LDR1:LDR-20261027-001:TOKEN00001',
    estimasi: null,
  );

  test('nota memuat identitas usaha, item, dan sisa pembayaran', () async {
    final bytes = await EscPosBuilder.receipt(receipt);
    final text = latin1.decode(bytes);

    expect(bytes, isNotEmpty);
    expect(text, contains('Laundry Bersih'));
    expect(text, contains('LDR-20261027-001'));
    expect(text, contains('Ibu Sari'));
    expect(text, contains('Cuci Kering'));
    expect(text, contains('2,5 kg'));
    expect(text, contains('Rp 22.500'));
    expect(text, contains('Dibayar'));
    expect(text, contains('Sisa'));
    expect(text, contains('Terima kasih'));
  });

  test('label memuat nota dan QR tanpa harga', () async {
    final bytes = await EscPosBuilder.label(label);
    final text = latin1.decode(bytes);

    expect(text, contains('LDR-20261027-001'));
    expect(text, contains('Ibu Sari'));
    expect(text, contains('2,5 kg'));
    expect(text, isNot(contains('Rp')));
    expect(text, isNot(contains('Total')));
    expect(_contains(bytes, [0x1D, 0x28, 0x6B]), isTrue);
  });

  test('label 58x30 tetap menghasilkan perintah cetak', () async {
    final bytes = await EscPosBuilder.label(label, labelSize: '58x30');
    expect(bytes, isNotEmpty);
    expect(_contains(bytes, [0x1D, 0x28, 0x6B]), isTrue);
  });

  test('halaman uji printer berisi QR', () async {
    final bytes = await EscPosBuilder.testPage('Laundry Bersih');
    expect(latin1.decode(bytes), contains('Uji printer'));
    expect(_contains(bytes, [0x1D, 0x28, 0x6B]), isTrue);
  });
}

bool _contains(List<int> haystack, List<int> needle) {
  for (var index = 0; index <= haystack.length - needle.length; index++) {
    var match = true;
    for (var offset = 0; offset < needle.length; offset++) {
      if (haystack[index + offset] != needle[offset]) {
        match = false;
        break;
      }
    }
    if (match) {
      return true;
    }
  }
  return false;
}
