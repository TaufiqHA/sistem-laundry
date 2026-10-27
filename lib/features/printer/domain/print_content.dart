import 'package:sistem_manajemen_laundry/core/utils/quantity.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/settings/domain/app_settings.dart';

class ReceiptItem {
  const ReceiptItem({
    required this.nama,
    required this.qtyMilli,
    required this.satuan,
    required this.hargaSatuan,
    required this.subtotal,
  });

  final String nama;
  final int qtyMilli;
  final String satuan;
  final int hargaSatuan;
  final int subtotal;
}

class ReceiptContent {
  const ReceiptContent({
    required this.businessName,
    required this.address,
    required this.phone,
    required this.footer,
    required this.nota,
    required this.customerName,
    required this.items,
    required this.subtotal,
    required this.diskon,
    required this.total,
    required this.dibayar,
    this.masuk,
  });

  factory ReceiptContent.fromDetail(OrderDetail detail, AppSettings settings) {
    final order = detail.order;
    return ReceiptContent(
      businessName: settings.displayName,
      address: settings.businessAddress,
      phone: settings.businessPhone,
      footer: settings.receiptFooter,
      nota: order.nomorNota,
      customerName: order.customerNama,
      masuk: order.tanggalMasuk,
      items: detail.items
          .map(
            (line) => ReceiptItem(
              nama: line.namaLayanan,
              qtyMilli: line.qtyMilli,
              satuan: line.satuan?.label ?? '',
              hargaSatuan: line.hargaSatuan,
              subtotal: line.subtotal,
            ),
          )
          .toList(growable: false),
      subtotal: detail.items.fold(0, (sum, line) => sum + line.subtotal),
      diskon: order.diskon,
      total: order.total,
      dibayar: detail.dibayar,
    );
  }

  final String businessName;
  final String address;
  final String phone;
  final String footer;
  final String nota;
  final String customerName;
  final DateTime? masuk;
  final List<ReceiptItem> items;
  final int subtotal;
  final int diskon;
  final int total;
  final int dibayar;

  int get piutang => total - dibayar;
}

class LabelContent {
  const LabelContent({
    required this.nota,
    required this.customerName,
    required this.itemLines,
    required this.qrPayload,
    this.estimasi,
  });

  factory LabelContent.fromDetail(OrderDetail detail) {
    final order = detail.order;
    return LabelContent(
      nota: order.nomorNota,
      customerName: order.customerNama,
      itemLines: detail.items
          .map(
            (line) =>
                '${line.namaLayanan} · '
                '${Quantity.format(line.qtyMilli, unit: line.satuan?.label)}',
          )
          .toList(growable: false),
      qrPayload: qrPayloadFor(order),
      estimasi: order.estimasiSelesai,
    );
  }

  final String nota;
  final String customerName;
  final List<String> itemLines;
  final String qrPayload;
  final DateTime? estimasi;
}
