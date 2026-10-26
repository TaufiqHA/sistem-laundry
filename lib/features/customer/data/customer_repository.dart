import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/utils/phone_number.dart';
import 'package:sistem_manajemen_laundry/features/customer/domain/customer.dart';

class CustomerRepository {
  CustomerRepository(this._db);

  final AppDatabase _db;

  Future<List<Customer>> list({String query = ''}) async {
    final search = query.trim();
    final builder = _db.select(_db.customers);

    if (search.isNotEmpty) {
      final digits = search.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.isEmpty) {
        builder.where((table) => table.nama.like('%$search%'));
      } else {
        final phone = PhoneNumber.normalize(digits);
        builder.where(
          (table) =>
              table.nama.like('%$search%') | table.telepon.like('%$phone%'),
        );
      }
    }

    builder.orderBy([(table) => OrderingTerm.asc(table.nama)]);
    final rows = await builder.get();
    return rows.map(_map).toList(growable: false);
  }

  Future<Customer?> getById(int id) async {
    final row = await (_db.select(
      _db.customers,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _map(row);
  }

  Future<Customer?> findByPhone(String phone, {int? exceptId}) async {
    final normalized = PhoneNumber.normalize(phone);
    if (normalized.isEmpty) {
      return null;
    }
    final rows = await (_db.select(
      _db.customers,
    )..where((table) => table.telepon.equals(normalized))).get();
    for (final row in rows) {
      if (row.id != exceptId) {
        return _map(row);
      }
    }
    return null;
  }

  Future<int> create({
    required String nama,
    required String telepon,
    String? alamat,
    String? catatan,
  }) {
    return _db
        .into(_db.customers)
        .insert(
          CustomersCompanion.insert(
            nama: nama.trim(),
            telepon: PhoneNumber.normalize(telepon),
            alamat: Value(_emptyToNull(alamat)),
            catatan: Value(_emptyToNull(catatan)),
          ),
        );
  }

  Future<void> update({
    required int id,
    required String nama,
    required String telepon,
    String? alamat,
    String? catatan,
  }) async {
    await (_db.update(
      _db.customers,
    )..where((table) => table.id.equals(id))).write(
      CustomersCompanion(
        nama: Value(nama.trim()),
        telepon: Value(PhoneNumber.normalize(telepon)),
        alamat: Value(_emptyToNull(alamat)),
        catatan: Value(_emptyToNull(catatan)),
      ),
    );
  }

  /// Total order, nilai belanja, dan piutang (total dikurangi pembayaran
  /// yang belum dihapus). Order yang dibatalkan tidak dihitung.
  Future<CustomerSummary> summary(int customerId) async {
    final row = await _db
        .customSelect(
          'SELECT COUNT(*) AS jumlah, '
          'COALESCE(SUM(o.total), 0) AS total, '
          'COALESCE(SUM(('
          '  SELECT COALESCE(SUM(p.jumlah), 0) FROM payments p '
          '  WHERE p.order_id = o.id AND p.dihapus_pada IS NULL'
          ')), 0) AS dibayar '
          'FROM orders o '
          'WHERE o.customer_id = ? AND o.dihapus_pada IS NULL',
          variables: [Variable.withInt(customerId)],
          readsFrom: {_db.orders, _db.payments},
        )
        .getSingle();

    final total = row.read<int>('total');
    final dibayar = row.read<int>('dibayar');
    return CustomerSummary(
      orderCount: row.read<int>('jumlah'),
      totalBelanja: total,
      piutang: total - dibayar,
    );
  }

  static Customer _map(CustomerRow row) {
    return Customer(
      id: row.id,
      nama: row.nama,
      telepon: row.telepon,
      alamat: row.alamat,
      catatan: row.catatan,
      poin: row.poin,
    );
  }

  static String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
