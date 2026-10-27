import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';

enum ScanOutcome {
  siap('Siap diproses'),
  sudahDiambil('Sudah diambil'),
  dibatalkan('Order dibatalkan'),
  tidakDikenal('Label tidak dikenal'),
  tidakValid('QR bukan dari aplikasi ini');

  const ScanOutcome(this.label);

  final String label;
}

class ScanResult {
  const ScanResult(this.outcome, {this.detail});

  final ScanOutcome outcome;
  final OrderDetail? detail;

  bool get bisaDimajukan =>
      outcome == ScanOutcome.siap &&
      detail != null &&
      detail!.order.status.next != null;
}
