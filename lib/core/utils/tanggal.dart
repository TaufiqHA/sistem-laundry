const _bulan = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

const _hari = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

/// Format tanggal tanpa bergantung pada data locale `intl`, supaya
/// tampilan sama di seluruh perangkat.
String formatTanggal(DateTime value) {
  final local = value.toLocal();
  return '${local.day} ${_bulan[local.month - 1]} ${local.year}';
}

String formatTanggalLengkap(DateTime value) {
  final local = value.toLocal();
  return '${_hari[local.weekday - 1]}, ${formatTanggal(local)}';
}

String formatJam(DateTime value) {
  final local = value.toLocal();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String formatTanggalJam(DateTime value) =>
    '${formatTanggal(value)} ${formatJam(value)}';

/// Kunci tanggal untuk penomoran nota, mis. `20261027`.
String tanggalKey(DateTime value) {
  final local = value.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}$month$day';
}
