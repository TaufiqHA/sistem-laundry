import 'package:sistem_manajemen_laundry/features/order/domain/order_status.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/status_change_source.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

class LaundryOrder {
  const LaundryOrder({
    required this.id,
    required this.nomorNota,
    required this.qrToken,
    required this.customerId,
    required this.customerNama,
    required this.customerTelepon,
    required this.tanggalMasuk,
    required this.status,
    required this.total,
    this.estimasiSelesai,
    this.catatan,
    this.diskon = 0,
  });

  final int id;
  final String nomorNota;
  final String qrToken;
  final int customerId;
  final String customerNama;
  final String customerTelepon;
  final DateTime tanggalMasuk;
  final DateTime? estimasiSelesai;
  final OrderStatus status;
  final int total;
  final int diskon;
  final String? catatan;
}

class OrderLine {
  const OrderLine({
    required this.id,
    required this.serviceId,
    required this.namaLayanan,
    required this.qtyMilli,
    required this.hargaSatuan,
    required this.subtotal,
    this.satuan,
  });

  final int id;
  final int serviceId;
  final String namaLayanan;
  final int qtyMilli;
  final int hargaSatuan;
  final int subtotal;
  final ServiceUnit? satuan;
}

class StatusChange {
  const StatusChange({
    required this.statusBaru,
    required this.sumber,
    required this.waktu,
    this.statusLama,
  });

  final OrderStatus? statusLama;
  final OrderStatus statusBaru;
  final StatusChangeSource sumber;
  final DateTime waktu;
}

class OrderDetail {
  const OrderDetail({
    required this.order,
    required this.items,
    required this.history,
    required this.dibayar,
  });

  final LaundryOrder order;
  final List<OrderLine> items;
  final List<StatusChange> history;
  final int dibayar;

  int get piutang => order.total - dibayar;

  bool get lunas => piutang <= 0;

  bool get bisaDibatalkan => dibayar == 0;
}

/// Item yang akan disimpan. Subtotal dihitung saat dibuat agar pembulatan
/// uang selalu di satu tempat.
class NewOrderItem {
  NewOrderItem({
    required this.serviceId,
    required this.namaLayanan,
    required this.qtyMilli,
    required this.hargaSatuan,
    this.satuan,
  });

  final int serviceId;
  final String namaLayanan;
  final int qtyMilli;
  final int hargaSatuan;
  final ServiceUnit? satuan;

  int get subtotal => (qtyMilli * hargaSatuan + 500) ~/ 1000;
}

enum OrderFilter {
  hariIni('Hari ini', null),
  semua('Semua', null),
  diterima('Diterima', OrderStatus.diterima),
  diproses('Diproses', OrderStatus.diproses),
  selesai('Selesai', OrderStatus.selesai),
  diambil('Diambil', OrderStatus.diambil);

  const OrderFilter(this.label, this.status);

  final String label;
  final OrderStatus? status;
}

class OrderException implements Exception {
  OrderException(this.message);

  final String message;

  @override
  String toString() => message;
}
