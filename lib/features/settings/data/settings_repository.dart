import 'package:sistem_manajemen_laundry/core/database/app_database.dart';

/// Kunci pengaturan yang dipakai lintas fitur. Nilai disimpan sebagai
/// teks; konversi tipe dilakukan di repository ini.
abstract final class SettingKeys {
  static const businessName = 'usaha_nama';
  static const businessPhone = 'usaha_telepon';
  static const businessAddress = 'usaha_alamat';
  static const receiptFooter = 'nota_footer';
  static const notaFormat = 'nota_format';
  static const labelSize = 'label_ukuran';
  static const overdueDays = 'batas_hari_belum_diambil';
  static const lastBackupAt = 'backup_terakhir';
}

class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Future<String?> get(String key) async {
    final row = await (_db.select(
      _db.settings,
    )..where((table) => table.kunci.equals(key))).getSingleOrNull();
    return row?.nilai;
  }

  Future<int?> getInt(String key) async {
    final raw = await get(key);
    return raw == null ? null : int.tryParse(raw);
  }

  Future<DateTime?> getDateTime(String key) async {
    final raw = await get(key);
    return raw == null ? null : DateTime.tryParse(raw)?.toLocal();
  }

  Future<void> set(String key, String value) {
    return _db
        .into(_db.settings)
        .insertOnConflictUpdate(
          SettingsCompanion.insert(kunci: key, nilai: value),
        );
  }

  Future<void> setInt(String key, int value) => set(key, '$value');

  Future<void> setDateTime(String key, DateTime value) {
    return set(key, value.toUtc().toIso8601String());
  }

  Future<Map<String, String>> all() async {
    final rows = await _db.select(_db.settings).get();
    return {for (final row in rows) row.kunci: row.nilai};
  }
}
