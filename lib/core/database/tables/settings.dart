import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/utils/clock.dart';

/// Penyimpanan kunci-nilai untuk pengaturan usaha, format nota, dan
/// preferensi cetak. Tipe data diatur di repository, bukan di tabel.
@DataClassName('Setting')
class Settings extends Table {
  TextColumn get kunci => text()();

  TextColumn get nilai => text()();

  DateTimeColumn get diubahPada => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {kunci};
}
