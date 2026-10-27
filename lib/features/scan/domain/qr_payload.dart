/// Isi QR pada label kantong: `LDR1:<nomor_nota>:<token>`.
class QrPayload {
  const QrPayload({required this.nota, required this.token});

  final String nota;
  final String token;

  static const prefix = 'LDR1';

  static QrPayload? parse(String raw) {
    final text = raw.trim();
    final parts = text.split(':');
    if (parts.length != 3 || parts[0] != prefix) {
      return null;
    }
    if (parts[1].isEmpty || parts[2].length < 8) {
      return null;
    }
    return QrPayload(nota: parts[1], token: parts[2]);
  }
}
