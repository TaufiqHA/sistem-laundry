import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/database/tables/orders.dart';
import 'package:sistem_manajemen_laundry/core/utils/clock.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_status.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/status_change_source.dart';

/// Jejak setiap perubahan status. Dipakai untuk tombol urungkan dan audit.
@DataClassName('StatusHistoryEntry')
@TableIndex(name: 'idx_status_history_order', columns: {#orderId})
class OrderStatusHistory extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get orderId =>
      integer().references(Orders, #id, onDelete: KeyAction.cascade)();

  /// Null saat order pertama kali dibuat.
  IntColumn get statusLama => intEnum<OrderStatus>().nullable()();

  IntColumn get statusBaru => intEnum<OrderStatus>()();

  IntColumn get sumber => intEnum<StatusChangeSource>()();

  DateTimeColumn get diubahPada => dateTime().clientDefault(nowUtc)();
}
