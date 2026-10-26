import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/utils/clock.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_status.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/status_change_source.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> insertCustomer({String telepon = '6281211112222'}) {
    return db
        .into(db.customers)
        .insert(CustomersCompanion.insert(nama: 'Ibu Sari', telepon: telepon));
  }

  Future<int> insertService({String nama = 'Cuci Kering'}) {
    return db
        .into(db.services)
        .insert(
          ServicesCompanion.insert(
            nama: nama,
            satuan: ServiceUnit.kg,
            harga: 7000,
          ),
        );
  }

  Future<int> insertOrder({
    required int customerId,
    String nomorNota = 'LDR-20261027-001',
    String qrToken = 'TOKEN00001',
    int total = 17500,
  }) {
    return db
        .into(db.orders)
        .insert(
          OrdersCompanion.insert(
            nomorNota: nomorNota,
            qrToken: qrToken,
            customerId: customerId,
            tanggalMasuk: nowUtc(),
            total: total,
          ),
        );
  }

  group('skema', () {
    test('semua tabel PRD ada', () async {
      final rows = await db
          .customSelect(
            "SELECT name FROM sqlite_master "
            "WHERE type = 'table' AND name NOT LIKE 'sqlite_%'",
          )
          .get();
      final tables = rows.map((row) => row.read<String>('name')).toSet();

      expect(
        tables,
        containsAll([
          'customers',
          'services',
          'orders',
          'order_items',
          'payments',
          'order_status_history',
          'expenses',
          'settings',
          'licenses',
          'nota_counters',
        ]),
      );
    });

    test('kolom memakai snake_case sesuai PRD', () async {
      final rows = await db.customSelect("PRAGMA table_info('orders')").get();
      final columns = rows.map((row) => row.read<String>('name')).toSet();

      expect(
        columns,
        containsAll([
          'nomor_nota',
          'qr_token',
          'customer_id',
          'tanggal_masuk',
          'estimasi_selesai',
          'diskon',
          'total',
          'dihapus_pada',
        ]),
      );
    });

    test('indeks untuk pencarian dan laporan sudah dibuat', () async {
      final rows = await db
          .customSelect("SELECT name FROM sqlite_master WHERE type = 'index'")
          .get();
      final indexes = rows.map((row) => row.read<String>('name')).toSet();

      expect(
        indexes,
        containsAll([
          'idx_customers_nama',
          'idx_customers_telepon',
          'idx_orders_customer',
          'idx_orders_tanggal_masuk',
          'idx_orders_status',
          'idx_order_items_order',
          'idx_payments_order',
          'idx_status_history_order',
          'idx_expenses_tanggal',
        ]),
      );
    });

    test('foreign key aktif dan menolak relasi yatim', () async {
      await expectLater(
        insertOrder(customerId: 999),
        throwsA(isA<Exception>()),
      );
    });

    test('nomor nota dan token QR unik', () async {
      final customerId = await insertCustomer();
      await insertOrder(customerId: customerId);

      await expectLater(
        insertOrder(customerId: customerId, qrToken: 'TOKEN00002'),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        insertOrder(customerId: customerId, nomorNota: 'LDR-20261027-002'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('transaksi dan integritas', () {
    test('transaksi gagal tidak meninggalkan data setengah jadi', () async {
      final customerId = await insertCustomer();

      await expectLater(
        db.transaction(() async {
          await insertOrder(customerId: customerId);
          throw StateError('dibatalkan di tengah');
        }),
        throwsA(isA<StateError>()),
      );

      expect(await db.select(db.orders).get(), isEmpty);
    });

    test('hapus order menghapus item lewat cascade', () async {
      final customerId = await insertCustomer();
      final serviceId = await insertService();
      final orderId = await insertOrder(customerId: customerId);

      await db
          .into(db.orderItems)
          .insert(
            OrderItemsCompanion.insert(
              orderId: orderId,
              serviceId: serviceId,
              namaLayanan: 'Cuci Kering',
              qtyMilli: 2500,
              hargaSatuan: 7000,
              subtotal: 17500,
            ),
          );

      await (db.delete(
        db.orders,
      )..where((table) => table.id.equals(orderId))).go();

      expect(await db.select(db.orderItems).get(), isEmpty);
    });

    test('status dan sumber perubahan dibaca kembali sebagai enum', () async {
      final customerId = await insertCustomer();
      final orderId = await insertOrder(customerId: customerId);

      await db
          .into(db.orderStatusHistory)
          .insert(
            OrderStatusHistoryCompanion.insert(
              orderId: orderId,
              statusBaru: OrderStatus.selesai,
              sumber: StatusChangeSource.scan,
            ),
          );

      final history = await db.select(db.orderStatusHistory).getSingle();
      expect(history.statusBaru, OrderStatus.selesai);
      expect(history.sumber, StatusChangeSource.scan);
      expect(history.statusLama, isNull);
    });

    test('penomoran nota per tanggal bisa dinaikkan berulang', () async {
      await db
          .into(db.notaCounters)
          .insertOnConflictUpdate(
            const NotaCountersCompanion(
              tanggal: Value('20261027'),
              urutan: Value(1),
            ),
          );
      await db
          .into(db.notaCounters)
          .insertOnConflictUpdate(
            const NotaCountersCompanion(
              tanggal: Value('20261027'),
              urutan: Value(2),
            ),
          );

      final rows = await db.select(db.notaCounters).get();
      expect(rows, hasLength(1));
      expect(rows.single.urutan, 2);
    });
  });
}
