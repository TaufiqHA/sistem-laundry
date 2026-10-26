import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/database/tables/orders.dart';
import 'package:sistem_manajemen_laundry/core/utils/clock.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment_method.dart';

@DataClassName('Payment')
@TableIndex(name: 'idx_payments_order', columns: {#orderId})
@TableIndex(name: 'idx_payments_tanggal', columns: {#tanggal})
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get orderId => integer().references(Orders, #id)();

  IntColumn get jumlah => integer()();

  IntColumn get metode => intEnum<PaymentMethod>()();

  DateTimeColumn get tanggal => dateTime()();

  TextColumn get catatan => text().withLength(max: 300).nullable()();

  DateTimeColumn get dibuatPada => dateTime().clientDefault(nowUtc)();

  DateTimeColumn get dihapusPada => dateTime().nullable()();
}
