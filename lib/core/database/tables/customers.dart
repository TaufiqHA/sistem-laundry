import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/utils/clock.dart';

@DataClassName('Customer')
@TableIndex(name: 'idx_customers_nama', columns: {#nama})
@TableIndex(name: 'idx_customers_telepon', columns: {#telepon})
class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get nama => text().withLength(min: 1, max: 80)();

  /// Disimpan ternormalisasi (`628...`), dipakai untuk pencarian dan WhatsApp.
  TextColumn get telepon => text().withLength(max: 20)();

  TextColumn get alamat => text().withLength(max: 200).nullable()();

  TextColumn get catatan => text().withLength(max: 300).nullable()();

  IntColumn get poin => integer().withDefault(const Constant(0))();

  DateTimeColumn get dibuatPada => dateTime().clientDefault(nowUtc)();
}
