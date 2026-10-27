import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'package:sistem_manajemen_laundry/features/printer/domain/printer_service.dart';

class BluetoothPrinterService implements PrinterService {
  @override
  Future<bool> isBluetoothEnabled() async {
    return PrintBluetoothThermal.bluetoothEnabled;
  }

  @override
  Future<List<PrinterDevice>> pairedDevices() async {
    final devices = await PrintBluetoothThermal.pairedBluetooths;
    return devices
        .map(
          (device) =>
              PrinterDevice(name: device.name, address: device.macAdress),
        )
        .toList(growable: false);
  }

  @override
  Future<bool> connect(PrinterDevice device) {
    return PrintBluetoothThermal.connect(macPrinterAddress: device.address);
  }

  @override
  Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect;
  }

  @override
  Future<bool> isConnected() {
    return PrintBluetoothThermal.connectionStatus;
  }

  @override
  Future<bool> write(List<int> bytes) {
    return PrintBluetoothThermal.writeBytes(bytes);
  }
}
