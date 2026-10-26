import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/database/tables/orders.dart';
import 'package:sistem_manajemen_laundry/core/database/tables/services.dart';
import 'package:sistem_manajemen_laundry/core/utils/clock.dart';

@DataClassName('OrderItem')
@TableIndex(name: 'idx_order_items_order', columns: {#orderId})
class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get orderId =>
      integer().references(Orders, #id, onDelete: KeyAction.cascade)();

  IntColumn get serviceId => integer().references(Services, #id)();

  /// Nama dan harga disalin agar perubahan layanan tidak mengubah order lama.
  TextColumn get namaLayanan => text().withLength(min: 1, max: 80)();

  /// 1/1000 satuan, mis. 2,5 kg = 2500.
  IntColumn get qtyMilli => integer()();

  IntColumn get hargaSatuan => integer()();

  IntColumn get subtotal => integer()();

  DateTimeColumn get dibuatPada => dateTime().clientDefault(nowUtc)();
}
