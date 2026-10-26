import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/utils/clock.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

@DataClassName('Service')
class Services extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get nama => text().withLength(min: 1, max: 80)();

  /// Kategori menyusul di rilis 1.0 (FR-02); kolomnya sudah disiapkan
  /// supaya tidak perlu migrasi.
  TextColumn get kategori => text().withLength(max: 40).nullable()();

  IntColumn get satuan => intEnum<ServiceUnit>()();

  IntColumn get harga => integer()();

  /// Layanan nonaktif tidak dihapus agar riwayat order tetap utuh.
  BoolColumn get aktif => boolean().withDefault(const Constant(true))();

  DateTimeColumn get dibuatPada => dateTime().clientDefault(nowUtc)();
}
