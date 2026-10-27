import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/features/printer/data/bluetooth_printer_service.dart';
import 'package:sistem_manajemen_laundry/features/printer/domain/printer_service.dart';

final printerServiceProvider = Provider<PrinterService>((ref) {
  return BluetoothPrinterService();
});
