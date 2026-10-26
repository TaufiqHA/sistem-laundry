import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/database/tables/customers.dart';
import 'package:sistem_manajemen_laundry/core/utils/clock.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_status.dart';

@DataClassName('Order')
@TableIndex(name: 'idx_orders_customer', columns: {#customerId})
@TableIndex(name: 'idx_orders_tanggal_masuk', columns: {#tanggalMasuk})
@TableIndex(name: 'idx_orders_status', columns: {#status})
class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Unik dan tidak dipakai ulang, termasuk setelah order dibatalkan.
  TextColumn get nomorNota => text().withLength(min: 3, max: 40).unique()();

  /// Token acak untuk label kantong; bukan nomor urut agar tidak bisa ditebak.
  TextColumn get qrToken => text().withLength(min: 8, max: 32).unique()();

  IntColumn get customerId => integer().references(Customers, #id)();

  DateTimeColumn get tanggalMasuk => dateTime()();

  DateTimeColumn get estimasiSelesai => dateTime().nullable()();

  IntColumn get status =>
      intEnum<OrderStatus>().withDefault(const Constant(0))();

  IntColumn get diskon => integer().withDefault(const Constant(0))();

  /// Snapshot: subtotal item dikurangi diskon, disimpan saat order dibuat.
  IntColumn get total => integer()();

  TextColumn get catatan => text().withLength(max: 500).nullable()();

  DateTimeColumn get dibuatPada => dateTime().clientDefault(nowUtc)();

  DateTimeColumn get diubahPada => dateTime().clientDefault(nowUtc)();

  DateTimeColumn get dihapusPada => dateTime().nullable()();
}
