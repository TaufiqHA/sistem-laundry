import 'dart:math';

import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/utils/clock.dart';
import 'package:sistem_manajemen_laundry/core/utils/quantity.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_status.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment_method.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/status_change_source.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

/// Pengisi data contoh untuk pengembangan dan uji performa.
/// Hanya dipanggil dari mode debug atau test, tidak pernah dari alur
/// pengguna biasa.
class DevSeeder {
  DevSeeder(this._db);

  final AppDatabase _db;

  static const _serviceNames = [
    ('Cuci Kering', ServiceUnit.kg, 7000),
    ('Cuci Setrika', ServiceUnit.kg, 9000),
    ('Setrika Saja', ServiceUnit.kg, 6000),
    ('Selimut', ServiceUnit.pcs, 15000),
    ('Kemeja', ServiceUnit.pcs, 5000),
  ];

  Future<void> clearAll() async {
    await _db.transaction(() async {
      await _db.delete(_db.orderStatusHistory).go();
      await _db.delete(_db.payments).go();
      await _db.delete(_db.orderItems).go();
      await _db.delete(_db.orders).go();
      await _db.delete(_db.customers).go();
      await _db.delete(_db.services).go();
      await _db.delete(_db.expenses).go();
      await _db.delete(_db.settings).go();
      await _db.delete(_db.licenses).go();
      await _db.delete(_db.notaCounters).go();
    });
  }

  Future<void> seedSample({int orderCount = 50}) {
    return seedOrders(count: orderCount);
  }

  /// Membuat order beserta item, riwayat status, dan pembayaran.
  /// Dipakai untuk uji performa dengan [count] besar.
  Future<void> seedOrders({
    required int count,
    int customerCount = 50,
    bool withPayments = true,
    bool withHistory = true,
    int seed = 42,
  }) async {
    final random = Random(seed);
    final now = nowUtc();

    await _db.transaction(() async {
      final customerIds = <int>[];
      for (var i = 0; i < customerCount; i++) {
        final id = await _db
            .into(_db.customers)
            .insert(
              CustomersCompanion.insert(
                nama: 'Pelanggan ${i + 1}',
                telepon: '62812${(10000000 + i).toString()}',
                alamat: Value('Jalan Contoh ${i + 1}'),
              ),
            );
        customerIds.add(id);
      }

      final serviceIds = <int>[];
      final servicePrices = <int>[];
      for (final service in _serviceNames) {
        final id = await _db
            .into(_db.services)
            .insert(
              ServicesCompanion.insert(
                nama: service.$1,
                satuan: service.$2,
                harga: service.$3,
              ),
            );
        serviceIds.add(id);
        servicePrices.add(service.$3);
      }

      final orders = <OrdersCompanion>[];
      final plans = <({int serviceIndex, int qtyMilli, int subtotal})>[];
      for (var i = 0; i < count; i++) {
        final createdAt = now.subtract(
          Duration(days: random.nextInt(365), hours: random.nextInt(24)),
        );
        final status = OrderStatus.values[i % OrderStatus.values.length];
        final serviceIndex = i % serviceIds.length;
        final qtyMilli = Quantity.fromDecimal(1 + random.nextInt(7));
        final subtotal =
            (qtyMilli * servicePrices[serviceIndex]) ~/ Quantity.scale;
        plans.add((
          serviceIndex: serviceIndex,
          qtyMilli: qtyMilli,
          subtotal: subtotal,
        ));

        orders.add(
          OrdersCompanion.insert(
            nomorNota:
                'LDR-${createdAt.year}${_two(createdAt.month)}'
                '${_two(createdAt.day)}-${i.toString().padLeft(6, '0')}',
            qrToken: 'T${i.toRadixString(36).padLeft(10, '0')}',
            customerId: customerIds[i % customerIds.length],
            tanggalMasuk: createdAt,
            estimasiSelesai: Value(createdAt.add(const Duration(days: 2))),
            status: Value(status),
            total: subtotal,
            dihapusPada: Value(
              i % 50 == 0 ? createdAt.add(const Duration(days: 1)) : null,
            ),
            dibuatPada: Value(createdAt),
            diubahPada: Value(createdAt),
          ),
        );
      }

      await _db.batch((batch) {
        batch.insertAll(_db.orders, orders, mode: InsertMode.insertOrIgnore);
      });

      final orderRows = await (_db.select(
        _db.orders,
      )..orderBy([(table) => OrderingTerm.asc(table.id)])).get();

      final items = <OrderItemsCompanion>[];
      final histories = <OrderStatusHistoryCompanion>[];
      final payments = <PaymentsCompanion>[];

      for (var index = 0; index < orderRows.length; index++) {
        final order = orderRows[index];
        final plan = plans[index];

        items.add(
          OrderItemsCompanion.insert(
            orderId: order.id,
            serviceId: serviceIds[plan.serviceIndex],
            namaLayanan: _serviceNames[plan.serviceIndex].$1,
            qtyMilli: plan.qtyMilli,
            hargaSatuan: servicePrices[plan.serviceIndex],
            subtotal: plan.subtotal,
          ),
        );

        if (withHistory) {
          histories.add(
            OrderStatusHistoryCompanion.insert(
              orderId: order.id,
              statusBaru: OrderStatus.diterima,
              sumber: StatusChangeSource.manual,
              diubahPada: Value(order.tanggalMasuk),
            ),
          );
          for (var step = 1; step <= order.status.index; step++) {
            histories.add(
              OrderStatusHistoryCompanion.insert(
                orderId: order.id,
                statusLama: Value(OrderStatus.values[step - 1]),
                statusBaru: OrderStatus.values[step],
                sumber: StatusChangeSource.manual,
                diubahPada: Value(
                  order.tanggalMasuk.add(Duration(hours: step * 6)),
                ),
              ),
            );
          }
        }

        if (withPayments && order.id % 10 != 0) {
          payments.add(
            PaymentsCompanion.insert(
              orderId: order.id,
              jumlah: order.total,
              metode: PaymentMethod.values[order.id % 3],
              tanggal: order.tanggalMasuk.add(const Duration(hours: 1)),
            ),
          );
        }
      }

      await _db.batch((batch) {
        batch.insertAll(_db.orderItems, items);
        if (histories.isNotEmpty) {
          batch.insertAll(_db.orderStatusHistory, histories);
        }
        if (payments.isNotEmpty) {
          batch.insertAll(_db.payments, payments);
        }
      });
    });
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
