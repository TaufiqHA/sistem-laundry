import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/utils/clock.dart';
import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment_method.dart';

class PaymentRepository {
  PaymentRepository(this._db);

  final AppDatabase _db;

  /// Mencatat pembayaran penuh atau cicilan. Semua aturan uang diperiksa
  /// di dalam transaksi agar dua pembayaran berurutan tidak bisa
  /// melewati sisa piutang.
  Future<int> add({
    required int orderId,
    required int jumlah,
    required PaymentMethod metode,
    required DateTime tanggal,
    String? catatan,
  }) {
    return _db.transaction(() async {
      final order = await (_db.select(
        _db.orders,
      )..where((table) => table.id.equals(orderId))).getSingleOrNull();

      if (order == null || order.dihapusPada != null) {
        throw PaymentException('Order tidak ditemukan atau sudah dibatalkan.');
      }
      if (jumlah <= 0) {
        throw PaymentException('Jumlah pembayaran harus lebih dari 0.');
      }

      final sisa = order.total - await _paidAmount(orderId);
      if (sisa <= 0) {
        throw PaymentException('Order ini sudah lunas.');
      }
      if (jumlah > sisa) {
        throw PaymentException(
          'Jumlah melebihi sisa piutang ${Rupiah.format(sisa)}.',
        );
      }

      return _db
          .into(_db.payments)
          .insert(
            PaymentsCompanion.insert(
              orderId: orderId,
              jumlah: jumlah,
              metode: metode,
              tanggal: tanggal.toUtc(),
              catatan: Value(_nullIfEmpty(catatan)),
            ),
          );
    });
  }

  /// Soft delete: pembayaran tidak hilang dari database, hanya tidak
  /// dihitung lagi. Piutang order otomatis naik kembali.
  Future<void> softDelete(int paymentId) async {
    final payment = await (_db.select(
      _db.payments,
    )..where((table) => table.id.equals(paymentId))).getSingleOrNull();
    if (payment == null) {
      throw PaymentException('Pembayaran tidak ditemukan.');
    }
    await (_db.update(_db.payments)
          ..where((table) => table.id.equals(paymentId)))
        .write(PaymentsCompanion(dihapusPada: Value(nowUtc())));
  }

  Future<List<Payment>> listForOrder(int orderId) async {
    final rows =
        await (_db.select(_db.payments)..where(
              (table) =>
                  table.orderId.equals(orderId) & table.dihapusPada.isNull(),
            ))
            .get();
    rows.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return rows
        .map(
          (row) => Payment(
            id: row.id,
            orderId: row.orderId,
            jumlah: row.jumlah,
            metode: row.metode,
            tanggal: row.tanggal,
            catatan: row.catatan,
          ),
        )
        .toList(growable: false);
  }

  Future<List<CustomerDebt>> debts({DebtSort sort = DebtSort.nominal}) async {
    final orderBy = switch (sort) {
      DebtSort.nominal => 'piutang DESC',
      DebtSort.terlama => 'sejak ASC',
    };

    final rows = await _db
        .customSelect(
          'SELECT customer_id, nama, telepon, '
          'SUM(sisa) AS piutang, COUNT(*) AS jumlah_order, '
          'MIN(tanggal_masuk) AS sejak '
          'FROM ('
          '  SELECT c.id AS customer_id, c.nama AS nama, '
          '    c.telepon AS telepon, o.tanggal_masuk AS tanggal_masuk, '
          '    o.total - COALESCE(('
          '      SELECT SUM(p.jumlah) FROM payments p '
          '      WHERE p.order_id = o.id AND p.dihapus_pada IS NULL'
          '    ), 0) AS sisa '
          '  FROM orders o '
          '  JOIN customers c ON c.id = o.customer_id '
          '  WHERE o.dihapus_pada IS NULL'
          ') '
          'WHERE sisa > 0 '
          'GROUP BY customer_id '
          'ORDER BY $orderBy',
          readsFrom: {_db.orders, _db.customers, _db.payments},
        )
        .get();

    return rows
        .map(
          (row) => CustomerDebt(
            customerId: row.read<int>('customer_id'),
            nama: row.read<String>('nama'),
            telepon: row.read<String>('telepon'),
            piutang: row.read<int>('piutang'),
            jumlahOrder: row.read<int>('jumlah_order'),
            sejak: DateTime.fromMillisecondsSinceEpoch(
              row.read<int>('sejak') * 1000,
            ),
          ),
        )
        .toList(growable: false);
  }

  Future<int> totalOutstanding() async {
    final row = await _db
        .customSelect(
          'SELECT COALESCE(SUM(o.total - COALESCE(('
          '  SELECT SUM(p.jumlah) FROM payments p '
          '  WHERE p.order_id = o.id AND p.dihapus_pada IS NULL'
          '), 0)), 0) AS total '
          'FROM orders o WHERE o.dihapus_pada IS NULL',
          readsFrom: {_db.orders, _db.payments},
        )
        .getSingle();
    return row.read<int>('total');
  }

  Future<int> _paidAmount(int orderId) async {
    final row = await _db
        .customSelect(
          'SELECT COALESCE(SUM(jumlah), 0) AS dibayar FROM payments '
          'WHERE order_id = ? AND dihapus_pada IS NULL',
          variables: [Variable.withInt(orderId)],
          readsFrom: {_db.payments},
        )
        .getSingle();
    return row.read<int>('dibayar');
  }

  static String? _nullIfEmpty(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
