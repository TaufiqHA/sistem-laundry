import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/features/report/domain/report_data.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

class ReportRepository {
  ReportRepository(this._db);

  final AppDatabase _db;

  Future<ReportData> load({
    required DateTime start,
    required DateTime end,
  }) async {
    final incomeRow = await _db
        .customSelect(
          'SELECT COALESCE(SUM(jumlah), 0) AS pemasukan FROM payments '
          'WHERE tanggal >= ? AND tanggal < ? AND dihapus_pada IS NULL',
          variables: [Variable.withDateTime(start), Variable.withDateTime(end)],
          readsFrom: {_db.payments},
        )
        .getSingle();

    final orderRow = await _db
        .customSelect(
          'SELECT COUNT(*) AS jumlah FROM orders '
          'WHERE tanggal_masuk >= ? AND tanggal_masuk < ? '
          'AND dihapus_pada IS NULL',
          variables: [Variable.withDateTime(start), Variable.withDateTime(end)],
          readsFrom: {_db.orders},
        )
        .getSingle();

    final serviceRows = await _db
        .customSelect(
          'SELECT oi.nama_layanan AS nama, s.satuan AS satuan, '
          'SUM(oi.qty_milli) AS qty, SUM(oi.subtotal) AS omzet, '
          'COUNT(DISTINCT oi.order_id) AS jumlah_order '
          'FROM order_items oi '
          'JOIN orders o ON o.id = oi.order_id '
          'LEFT JOIN services s ON s.id = oi.service_id '
          'WHERE o.tanggal_masuk >= ? AND o.tanggal_masuk < ? '
          'AND o.dihapus_pada IS NULL '
          'GROUP BY oi.nama_layanan, s.satuan '
          'ORDER BY omzet DESC '
          'LIMIT 5',
          variables: [Variable.withDateTime(start), Variable.withDateTime(end)],
          readsFrom: {_db.orderItems, _db.orders, _db.services},
        )
        .get();

    final expenseRows = await _db
        .customSelect(
          'SELECT id, kategori, jumlah, tanggal, catatan FROM expenses '
          'WHERE tanggal >= ? AND tanggal < ? '
          'ORDER BY tanggal DESC, id DESC',
          variables: [Variable.withDateTime(start), Variable.withDateTime(end)],
          readsFrom: {_db.expenses},
        )
        .get();

    final expenses = expenseRows
        .map(
          (row) => ExpenseEntry(
            id: row.read<int>('id'),
            kategori: row.read<String>('kategori'),
            jumlah: row.read<int>('jumlah'),
            tanggal: DateTime.fromMillisecondsSinceEpoch(
              row.read<int>('tanggal') * 1000,
            ),
            catatan: row.read<String?>('catatan'),
          ),
        )
        .toList(growable: false);

    final expenseTotal = expenses.fold(0, (sum, item) => sum + item.jumlah);

    return ReportData(
      orderCount: orderRow.read<int>('jumlah'),
      income: incomeRow.read<int>('pemasukan'),
      expenseTotal: expenseTotal,
      topServices: serviceRows
          .map((row) {
            final satuanIndex = row.read<int?>('satuan');
            return ServiceSales(
              nama: row.read<String>('nama'),
              satuan: satuanIndex == null
                  ? null
                  : ServiceUnit.values[satuanIndex],
              qtyMilli: row.read<int>('qty'),
              revenue: row.read<int>('omzet'),
              orderCount: row.read<int>('jumlah_order'),
            );
          })
          .toList(growable: false),
      expenses: expenses,
    );
  }

  Future<int> addExpense({
    required String kategori,
    required int jumlah,
    required DateTime tanggal,
    String? catatan,
  }) {
    return _db
        .into(_db.expenses)
        .insert(
          ExpensesCompanion.insert(
            kategori: kategori.trim(),
            jumlah: jumlah,
            tanggal: tanggal.toUtc(),
            catatan: Value(_nullIfEmpty(catatan)),
          ),
        );
  }

  Future<void> deleteExpense(int id) async {
    await (_db.delete(
      _db.expenses,
    )..where((table) => table.id.equals(id))).go();
  }

  static String? _nullIfEmpty(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
