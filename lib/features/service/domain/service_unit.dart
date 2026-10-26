/// Satuan layanan. Nilai enum disimpan sebagai index di database,
/// jadi urutannya tidak boleh diubah setelah rilis.
enum ServiceUnit {
  kg(label: 'kg', longLabel: 'kilogram'),
  pcs(label: 'pcs', longLabel: 'potong'),
  meter(label: 'm', longLabel: 'meter');

  const ServiceUnit({required this.label, required this.longLabel});

  final String label;
  final String longLabel;
}
