import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/features/settings/domain/app_settings.dart';

/// Kunci pengaturan yang dipakai lintas fitur. Nilai disimpan sebagai
/// teks; konversi tipe dilakukan di repository ini.
abstract final class SettingKeys {
  static const businessName = 'usaha_nama';
  static const businessPhone = 'usaha_telepon';
  static const businessAddress = 'usaha_alamat';
  static const receiptFooter = 'nota_footer';
  static const notaFormat = 'nota_format';
  static const labelSize = 'label_ukuran';
  static const paperWidth = 'kertas_lebar_mm';
  static const printerName = 'printer_nama';
  static const printerAddress = 'printer_alamat';
  static const overdueDays = 'batas_hari_belum_diambil';
  static const lastBackupAt = 'backup_terakhir';
  static const onboardingDone = 'onboarding_selesai';
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

  Future<void> remove(String key) async {
    await (_db.delete(
      _db.settings,
    )..where((table) => table.kunci.equals(key))).go();
  }

  Future<void> setDateTime(String key, DateTime value) {
    return set(key, value.toUtc().toIso8601String());
  }

  Future<Map<String, String>> all() async {
    final rows = await _db.select(_db.settings).get();
    return {for (final row in rows) row.kunci: row.nilai};
  }

  Future<AppSettings> load() async {
    final values = await all();
    return AppSettings(
      businessName: values[SettingKeys.businessName] ?? '',
      businessPhone: values[SettingKeys.businessPhone] ?? '',
      businessAddress: values[SettingKeys.businessAddress] ?? '',
      receiptFooter: values[SettingKeys.receiptFooter] ?? '',
      notaFormat:
          values[SettingKeys.notaFormat] ?? AppSettings.defaultNotaFormat,
      labelSize: values[SettingKeys.labelSize] ?? AppSettings.defaultLabelSize,
      paperWidth:
          int.tryParse(values[SettingKeys.paperWidth] ?? '') ??
          AppSettings.defaultPaperWidth,
      printerName: values[SettingKeys.printerName] ?? '',
      printerAddress: values[SettingKeys.printerAddress] ?? '',
      lastBackupAt: DateTime.tryParse(values[SettingKeys.lastBackupAt] ?? '')
          ?.toLocal(),
      overdueDays:
          int.tryParse(values[SettingKeys.overdueDays] ?? '') ??
          AppSettings.defaultOverdueDays,
      onboardingDone: values[SettingKeys.onboardingDone] == '1',
    );
  }

  Future<void> saveBusiness({
    required String name,
    required String phone,
    required String address,
    required String receiptFooter,
  }) async {
    await set(SettingKeys.businessName, name.trim());
    await set(SettingKeys.businessPhone, phone.trim());
    await set(SettingKeys.businessAddress, address.trim());
    await set(SettingKeys.receiptFooter, receiptFooter.trim());
  }

  Future<void> setNotaFormat(String format) {
    return set(SettingKeys.notaFormat, format.trim());
  }

  Future<void> setLabelSize(String size) {
    return set(SettingKeys.labelSize, size);
  }

  Future<void> setPaperWidth(int millimeters) {
    return setInt(SettingKeys.paperWidth, millimeters);
  }

  Future<void> setPrinter({
    required String name,
    required String address,
  }) async {
    await set(SettingKeys.printerName, name);
    await set(SettingKeys.printerAddress, address);
  }

  Future<({String name, String address})?> printer() async {
    final address = await get(SettingKeys.printerAddress);
    if (address == null || address.isEmpty) {
      return null;
    }
    return (
      name: await get(SettingKeys.printerName) ?? 'Printer',
      address: address,
    );
  }

  Future<void> setOverdueDays(int days) {
    return setInt(SettingKeys.overdueDays, days);
  }

  Future<void> completeOnboarding() {
    return set(SettingKeys.onboardingDone, '1');
  }

  Future<bool> isOnboardingDone() async {
    return await get(SettingKeys.onboardingDone) == '1';
  }
}
