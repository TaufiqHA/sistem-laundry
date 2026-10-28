import 'package:sistem_manajemen_laundry/core/utils/phone_number.dart';
import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/core/utils/tanggal.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment.dart';

/// Pesan WhatsApp disusun tanpa aplikasi pihak ketiga agar bisa diuji.
abstract final class WhatsAppMessage {
  static String invoice(OrderDetail detail, {required String businessName}) {
    final order = detail.order;
    final lines = <String>[
      'Halo ${order.customerNama}, terima kasih sudah mencuci di '
          '$businessName.',
      '',
      'No. Nota: ${order.nomorNota}',
      'Total: ${Rupiah.format(order.total)}',
      if (detail.dibayar > 0) 'Dibayar: ${Rupiah.format(detail.dibayar)}',
      if (detail.piutang > 0) 'Sisa: ${Rupiah.format(detail.piutang)}',
      if (order.estimasiSelesai != null)
        'Estimasi selesai: ${formatTanggalJam(order.estimasiSelesai!)}',
      '',
      'Cucian bisa diambil setelah kami kabari kembali.',
    ];
    return lines.join('\n');
  }

  static String ready(OrderDetail detail, {required String businessName}) {
    final order = detail.order;
    return [
      'Halo ${order.customerNama}, cucian dengan nota ${order.nomorNota} '
          'sudah selesai dan siap diambil di $businessName.',
      if (detail.piutang > 0)
        'Sisa pembayaran: ${Rupiah.format(detail.piutang)}.',
      '',
      'Terima kasih.',
    ].join('\n');
  }

  static String debt(CustomerDebt debt, {required String businessName}) {
    return [
      'Halo ${debt.nama}, ini pengingat dari $businessName.',
      'Tercatat piutang sebesar ${Rupiah.format(debt.piutang)} '
          'dari ${debt.jumlahOrder} order.',
      if (debt.sejak.isBefore(DateTime.now()))
        'Utang tertua sejak ${formatTanggal(debt.sejak)}.',
      '',
      'Mohon konfirmasi jika sudah membayar. Terima kasih.',
    ].join('\n');
  }
}

abstract final class WhatsAppLink {
  static Uri? build(String phone, String message) {
    final normalized = PhoneNumber.normalize(phone);
    if (normalized.length < 9) {
      return null;
    }
    return Uri.parse(
      'https://wa.me/$normalized?text=${Uri.encodeComponent(message)}',
    );
  }
}
