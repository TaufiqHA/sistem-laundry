import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/utils/clock.dart';

/// Hasil aktivasi lisensi offline. Satu perangkat satu baris.
@DataClassName('License')
class Licenses extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get kode => text().unique()();

  TextColumn get idPerangkat => text().withLength(max: 80)();

  DateTimeColumn get diaktifkanPada => dateTime().clientDefault(nowUtc)();
}
