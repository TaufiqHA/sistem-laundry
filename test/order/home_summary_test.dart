import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/utils/clock.dart';
import 'package:sistem_manajemen_laundry/features/customer/data/customer_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/data/order_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/data/payment_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment_method.dart';
import 'package:sistem_manajemen_laundry/features/service/data/service_repository.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

void main() {
  late AppDatabase db;
  late OrderRepository orders;
  late PaymentRepository payments;
  late int customerId;
  late int serviceId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    orders = OrderRepository(db);
    payments = PaymentRepository(db);

    customerId = await CustomerRepository(db)
        .create(nama: 'Ibu Sari', telepon: '081234567890');
    serviceId = await ServiceRepository(db)
        .create(nama: 'Cuci Kering', satuan: ServiceUnit.kg, harga: 7000);
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> createOrder() {
    return orders.create(
      customerId: customerId,
      items: [
        NewOrderItem(
          serviceId: serviceId,
          namaLayanan: 'Cuci Kering',
          qtyMilli: 2500,
          hargaSatuan: 7000,
          satuan: ServiceUnit.kg,
        ),
      ],
      estimasiSelesai: DateTime.now().add(const Duration(days: 2)),
    );
  }

  Future<void> backdate(int orderId, int daysAgo) async {
    await (db.update(
      db.orders,
    )..where((table) => table.id.equals(orderId))).write(
      OrdersCompanion(
        tanggalMasuk: Value(nowUtc().subtract(Duration(days: daysAgo))),
      ),
    );
  }

  test('ringkasan hari ini: order, pemasukan, piutang baru', () async {
    final orderId = await createOrder();
    await payments.add(
      orderId: orderId,
      jumlah: 10000,
      metode: PaymentMethod.tunai,
      tanggal: DateTime.now(),
    );

    final summary = await orders.todaySummary(overdueDays: 7);

    expect(summary.orderCount, 1);
    expect(summary.income, 10000);
    expect(summary.newReceivable, 7500);
    expect(summary.readyCount, 0);
    expect(summary.overdueCount, 0);
  });

  test('siap diambil muncul setelah status Selesai', () async {
    final orderId = await createOrder();
    await orders.advanceStatus(orderId);
    await orders.advanceStatus(orderId);

    final summary = await orders.todaySummary(overdueDays: 7);
    final ready = await orders.listReady();

    expect(summary.readyCount, 1);
    expect(ready.map((order) => order.id), [orderId]);
  });

  test('cucian lama yang belum diambil masuk daftar menumpuk', () async {
    final orderId = await createOrder();
    await backdate(orderId, 10);

    final summary = await orders.todaySummary(overdueDays: 7);
    final overdue = await orders.listOverdue(days: 7);

    expect(summary.orderCount, 0);
    expect(summary.overdueCount, 1);
    expect(overdue.map((order) => order.id), [orderId]);
  });

  test('order yang sudah diambil tidak dihitung menumpuk', () async {
    final orderId = await createOrder();
    await backdate(orderId, 10);
    for (var step = 0; step < 3; step++) {
      await orders.advanceStatus(orderId);
    }

    final summary = await orders.todaySummary(overdueDays: 7);
    final overdue = await orders.listOverdue(days: 7);

    expect(summary.overdueCount, 0);
    expect(overdue, isEmpty);
  });

  test('order batal tidak masuk ringkasan maupun daftar', () async {
    final orderId = await createOrder();
    await orders.cancel(orderId);

    final summary = await orders.todaySummary(overdueDays: 7);
    final ready = await orders.listReady();
    final overdue = await orders.listOverdue(days: 7);

    expect(summary.orderCount, 0);
    expect(summary.newReceivable, 0);
    expect(ready, isEmpty);
    expect(overdue, isEmpty);
  });
}
