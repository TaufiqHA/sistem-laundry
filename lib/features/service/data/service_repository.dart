import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/laundry_service.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

class ServiceRepository {
  ServiceRepository(this._db);

  final AppDatabase _db;

  Future<List<LaundryService>> list({bool includeInactive = true}) async {
    final query = _db.select(_db.services);
    if (!includeInactive) {
      query.where((table) => table.aktif.equals(true));
    }
    query.orderBy([
      (table) => OrderingTerm.asc(table.aktif),
      (table) => OrderingTerm.asc(table.nama),
    ]);
    final rows = await query.get();
    return rows
        .map(
          (row) => LaundryService(
            id: row.id,
            nama: row.nama,
            satuan: row.satuan,
            harga: row.harga,
            aktif: row.aktif,
          ),
        )
        .toList(growable: false);
  }

  Future<int> create({
    required String nama,
    required ServiceUnit satuan,
    required int harga,
  }) {
    return _db
        .into(_db.services)
        .insert(
          ServicesCompanion.insert(
            nama: nama.trim(),
            satuan: satuan,
            harga: harga,
          ),
        );
  }

  Future<void> update({
    required int id,
    required String nama,
    required ServiceUnit satuan,
    required int harga,
  }) async {
    await (_db.update(
      _db.services,
    )..where((table) => table.id.equals(id))).write(
      ServicesCompanion(
        nama: Value(nama.trim()),
        satuan: Value(satuan),
        harga: Value(harga),
      ),
    );
  }

  /// Layanan tidak dihapus, hanya dinonaktifkan agar riwayat order tetap utuh.
  Future<void> setActive(int id, {required bool aktif}) async {
    await (_db.update(_db.services)..where((table) => table.id.equals(id)))
        .write(ServicesCompanion(aktif: Value(aktif)));
  }

  Future<bool> isNameTaken(String nama, {int? exceptId}) async {
    final target = nama.trim().toLowerCase();
    final rows = await _db.select(_db.services).get();
    return rows.any(
      (row) => row.id != exceptId && row.nama.trim().toLowerCase() == target,
    );
  }
}
