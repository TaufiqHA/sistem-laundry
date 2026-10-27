import 'package:sistem_manajemen_laundry/features/order/domain/payment_method.dart';

class Payment {
  const Payment({
    required this.id,
    required this.orderId,
    required this.jumlah,
    required this.metode,
    required this.tanggal,
    this.catatan,
  });

  final int id;
  final int orderId;
  final int jumlah;
  final PaymentMethod metode;
  final DateTime tanggal;
  final String? catatan;
}

enum DebtSort {
  nominal('Nominal terbesar'),
  terlama('Utang terlama');

  const DebtSort(this.label);

  final String label;
}

/// Satu baris piutang per pelanggan, dihitung dari semua order aktif
/// dikurangi pembayaran yang belum dihapus.
class CustomerDebt {
  const CustomerDebt({
    required this.customerId,
    required this.nama,
    required this.telepon,
    required this.piutang,
    required this.jumlahOrder,
    required this.sejak,
  });

  final int customerId;
  final String nama;
  final String telepon;
  final int piutang;
  final int jumlahOrder;

  /// Tanggal order tertua yang masih berutang.
  final DateTime sejak;
}

class PaymentException implements Exception {
  PaymentException(this.message);

  final String message;

  @override
  String toString() => message;
}
