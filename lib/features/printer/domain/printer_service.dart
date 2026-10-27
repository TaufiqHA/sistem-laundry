class PrinterDevice {
  const PrinterDevice({required this.name, required this.address});

  final String name;

  /// Alamat MAC Bluetooth.
  final String address;
}

abstract interface class PrinterService {
  Future<bool> isBluetoothEnabled();

  Future<List<PrinterDevice>> pairedDevices();

  Future<bool> connect(PrinterDevice device);

  Future<void> disconnect();

  Future<bool> isConnected();

  Future<bool> write(List<int> bytes);
}
