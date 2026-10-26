import 'package:drift/drift.dart';

/// Penomoran nota per tanggal. Dinaikkan di dalam transaksi yang sama
/// dengan pembuatan order supaya tidak ada nomor kembar.
@DataClassName('NotaCounter')
class NotaCounters extends Table {
  /// Format `yyyyMMdd`, mis. `20261027`.
  TextColumn get tanggal => text().withLength(min: 8, max: 8)();

  IntColumn get urutan => integer()();

  @override
  Set<Column<Object>> get primaryKey => {tanggal};
}
