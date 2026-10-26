import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/utils/clock.dart';

@DataClassName('Expense')
@TableIndex(name: 'idx_expenses_tanggal', columns: {#tanggal})
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get kategori => text().withLength(min: 1, max: 40)();

  IntColumn get jumlah => integer()();

  DateTimeColumn get tanggal => dateTime()();

  TextColumn get catatan => text().withLength(max: 300).nullable()();

  DateTimeColumn get dibuatPada => dateTime().clientDefault(nowUtc)();
}
