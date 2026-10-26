/// Status cucian. Hanya boleh maju satu tahap; aturan transisi lengkap
/// ada di domain dan dipakai jalur manual maupun scan.
///
/// Nilai disimpan sebagai index di database. Jangan mengubah urutan
/// setelah ada data; tambahkan status baru hanya di akhir.
enum OrderStatus {
  diterima('Diterima'),
  diproses('Diproses'),
  selesai('Selesai'),
  diambil('Diambil');

  const OrderStatus(this.label);

  final String label;

  bool get isFinal => this == OrderStatus.diambil;

  OrderStatus? get next {
    final index = this.index + 1;
    return index < OrderStatus.values.length ? OrderStatus.values[index] : null;
  }
}
