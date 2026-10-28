import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

class LaundryService {
  const LaundryService({
    required this.id,
    required this.nama,
    required this.satuan,
    required this.harga,
    required this.aktif,
    this.kategori,
  });

  final int id;
  final String nama;
  final ServiceUnit satuan;
  final int harga;
  final bool aktif;
  final String? kategori;
}
