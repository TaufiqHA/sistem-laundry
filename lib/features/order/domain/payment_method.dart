/// Metode pembayaran. QRIS dicatat manual karena aplikasi tidak
/// terhubung ke penyedia pembayaran.
enum PaymentMethod {
  tunai('Tunai'),
  transfer('Transfer'),
  qris('QRIS');

  const PaymentMethod(this.label);

  final String label;
}
