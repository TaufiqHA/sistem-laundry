import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/utils/clock.dart';
import 'package:sistem_manajemen_laundry/features/customer/data/customer_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/data/order_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_status.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment_method.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/scan_result.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/status_change_source.dart';
import 'package:sistem_manajemen_laundry/features/service/data/service_repository.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';
import 'package:sistem_manajemen_laundry/features/settings/data/settings_repository.dart';

void main() {
  late AppDatabase db;
  late OrderRepository repository;
  late CustomerRepository customers;
  late ServiceRepository services;
  late int customerId;
  late int serviceId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = OrderRepository(db);
    customers = CustomerRepository(db);
    services = ServiceRepository(db);

    customerId = await customers.create(
      nama: 'Ibu Sari',
      telepon: '081234567890',
    );
    serviceId = await services.create(
      nama: 'Cuci Kering',
      satuan: ServiceUnit.kg,
      harga: 7000,
    );
  });

  tearDown(() async {
    await db.close();
  });

  NewOrderItem item({
    int qtyMilli = 2500,
    int hargaSatuan = 7000,
    int? service,
  }) {
    return NewOrderItem(
      serviceId: service ?? serviceId,
      namaLayanan: 'Cuci Kering',
      qtyMilli: qtyMilli,
      hargaSatuan: hargaSatuan,
      satuan: ServiceUnit.kg,
    );
  }

  Future<int> createOrder({
    int? custId,
    List<NewOrderItem>? items,
    int diskon = 0,
  }) {
    return repository.create(
      customerId: custId ?? customerId,
      items: items ?? [item()],
      estimasiSelesai: DateTime.now().add(const Duration(days: 2)),
      diskon: diskon,
    );
  }

  test('membuat order dengan nomor nota, token, dan riwayat', () async {
    final id = await createOrder();

    final detail = await repository.getDetail(id);
    expect(detail, isNotNull);
    expect(detail!.order.nomorNota, startsWith('LDR-'));
    expect(detail.order.nomorNota, endsWith('-001'));
    expect(detail.order.qrToken, hasLength(10));
    expect(detail.order.status, OrderStatus.diterima);
    expect(detail.order.total, 17500);
    expect(detail.items, hasLength(1));
    expect(detail.items.single.subtotal, 17500);
    expect(detail.items.single.satuan, ServiceUnit.kg);
    expect(detail.history, hasLength(1));
    expect(detail.history.single.statusLama, isNull);
    expect(detail.history.single.statusBaru, OrderStatus.diterima);
    expect(detail.dibayar, 0);
    expect(detail.piutang, 17500);
  });

  test('nomor nota berurutan pada tanggal yang sama', () async {
    final first = await createOrder();
    final second = await createOrder();

    final firstDetail = await repository.getDetail(first);
    final secondDetail = await repository.getDetail(second);

    expect(firstDetail!.order.nomorNota, endsWith('-001'));
    expect(secondDetail!.order.nomorNota, endsWith('-002'));
    expect(firstDetail.order.qrToken, isNot(secondDetail.order.qrToken));
  });

  test('format nomor nota mengikuti pengaturan usaha', () async {
    await SettingsRepository(db).setNotaFormat('INV-{tanggal}-{urut}');

    final id = await createOrder();
    final detail = await repository.getDetail(id);

    expect(detail!.order.nomorNota, startsWith('INV-'));
    expect(detail.order.nomorNota, endsWith('-001'));
  });

  test('diskon mengurangi total tanpa mengubah subtotal item', () async {
    final id = await createOrder(diskon: 500);
    final detail = await repository.getDetail(id);

    expect(detail!.order.total, 17000);
    expect(detail.items.single.subtotal, 17500);
    expect(detail.order.diskon, 500);
  });

  test('daftar hari ini memisahkan order lama dan order batal', () async {
    final todayId = await createOrder();
    final oldId = await insertOldOrder(db, customerId, serviceId);
    final deletedId = await createOrder();
    await repository.cancel(deletedId);

    final today = await repository.list(filter: OrderFilter.hariIni);
    final all = await repository.list(filter: OrderFilter.semua);

    expect(today.map((order) => order.id), [todayId]);
    expect(all.map((order) => order.id), [todayId, oldId]);
    expect(all.map((order) => order.id), isNot(contains(deletedId)));
  });

  test('pencarian memakai nota, nama, dan telepon', () async {
    final id = await createOrder();

    expect((await repository.list(query: 'LDR')).map((o) => o.id), [id]);
    expect((await repository.list(query: 'sari')).map((o) => o.id), [id]);
    expect((await repository.list(query: '0812')).map((o) => o.id), [id]);
    expect((await repository.list(query: '62812')).map((o) => o.id), [id]);
    expect(await repository.list(query: 'tidak ada'), isEmpty);
  });

  test('filter status hanya mengembalikan order yang sesuai', () async {
    final first = await createOrder();
    final second = await createOrder();
    await (db.update(db.orders)..where((table) => table.id.equals(second)))
        .write(const OrdersCompanion(status: Value(OrderStatus.selesai)));

    final selesai = await repository.list(filter: OrderFilter.selesai);
    expect(selesai.map((order) => order.id), [second]);

    final diterima = await repository.list(filter: OrderFilter.diterima);
    expect(diterima.map((order) => order.id), [first]);
  });

  test('mengubah order mengganti item dan menghitung ulang total', () async {
    final id = await createOrder();

    await repository.update(
      id: id,
      customerId: customerId,
      items: [item(qtyMilli: 5000)],
      estimasiSelesai: DateTime.now().add(const Duration(days: 3)),
      catatan: 'Tambahan',
    );

    final detail = await repository.getDetail(id);
    expect(detail!.items, hasLength(1));
    expect(detail.items.single.qtyMilli, 5000);
    expect(detail.order.total, 35000);
    expect(detail.order.catatan, 'Tambahan');
  });

  test('perubahan ditolak kalau total lebih kecil dari pembayaran', () async {
    final id = await createOrder();

    await db
        .into(db.payments)
        .insert(
          PaymentsCompanion.insert(
            orderId: id,
            jumlah: 20000,
            metode: PaymentMethod.tunai,
            tanggal: nowUtc(),
          ),
        );

    await expectLater(
      repository.update(
        id: id,
        customerId: customerId,
        items: [item(qtyMilli: 1000)],
        estimasiSelesai: DateTime.now(),
      ),
      throwsA(isA<OrderException>()),
    );

    final detail = await repository.getDetail(id);
    expect(detail!.order.total, 17500);
  });

  test('order dengan pembayaran tidak bisa dibatalkan', () async {
    final id = await createOrder();
    await db
        .into(db.payments)
        .insert(
          PaymentsCompanion.insert(
            orderId: id,
            jumlah: 5000,
            metode: PaymentMethod.tunai,
            tanggal: nowUtc(),
          ),
        );

    await expectLater(repository.cancel(id), throwsA(isA<OrderException>()));
    expect(await repository.list(filter: OrderFilter.semua), hasLength(1));
  });

  test('riwayat per pelanggan diurutkan dari yang terbaru', () async {
    final first = await createOrder();
    final second = await createOrder();

    final orders = await repository.listByCustomer(customerId);

    expect(orders.map((order) => order.id), [second, first]);
  });

  test('memajukan status menulis riwayat manual', () async {
    final id = await createOrder();

    final next = await repository.advanceStatus(id);

    expect(next, OrderStatus.diproses);
    final detail = await repository.getDetail(id);
    expect(detail!.order.status, OrderStatus.diproses);
    expect(detail.history, hasLength(2));
    expect(detail.history.last.sumber, StatusChangeSource.manual);
    expect(detail.history.last.statusLama, OrderStatus.diterima);
  });

  test('status Diambil tidak bisa dimajukan lagi', () async {
    final id = await createOrder();
    for (var step = 0; step < 3; step++) {
      await repository.advanceStatus(id);
    }

    final detail = await repository.getDetail(id);
    expect(detail!.order.status, OrderStatus.diambil);
    await expectLater(
      repository.advanceStatus(id),
      throwsA(isA<OrderException>()),
    );
  });

  test('order batal tidak bisa dimajukan', () async {
    final id = await createOrder();
    await repository.cancel(id);

    await expectLater(
      repository.advanceStatus(id),
      throwsA(isA<OrderException>()),
    );
  });

  test('urungkan mengembalikan status dan menulis riwayat', () async {
    final id = await createOrder();
    await repository.advanceStatus(id);

    final previous = await repository.undoLastStatus(id);

    expect(previous, OrderStatus.diterima);
    final detail = await repository.getDetail(id);
    expect(detail!.order.status, OrderStatus.diterima);
    expect(detail.history, hasLength(3));
    expect(detail.history.last.sumber, StatusChangeSource.urungkan);
    expect(detail.history.last.statusBaru, OrderStatus.diterima);
  });

  test('urungkan tanpa perubahan ditolak', () async {
    final id = await createOrder();

    await expectLater(
      repository.undoLastStatus(id),
      throwsA(isA<OrderException>()),
    );
  });

  test('urungkan dua kali berturut-turut ditolak', () async {
    final id = await createOrder();
    await repository.advanceStatus(id);
    await repository.undoLastStatus(id);

    await expectLater(
      repository.undoLastStatus(id),
      throwsA(isA<OrderException>()),
    );
  });

  test('scan token menemukan order yang siap diproses', () async {
    final id = await createOrder();
    final detail = await repository.getDetail(id);

    final result = await repository.lookupByToken(detail!.order.qrToken);

    expect(result.outcome, ScanOutcome.siap);
    expect(result.bisaDimajukan, isTrue);
    expect(result.detail!.order.id, id);
  });

  test('scan token order yang sudah diambil tidak bisa dimajukan', () async {
    final id = await createOrder();
    for (var step = 0; step < 3; step++) {
      await repository.advanceStatus(id);
    }
    final token = (await repository.getDetail(id))!.order.qrToken;

    final result = await repository.lookupByToken(token);

    expect(result.outcome, ScanOutcome.sudahDiambil);
    expect(result.bisaDimajukan, isFalse);
  });

  test('scan token order batal dikenali', () async {
    final id = await createOrder();
    final token = (await repository.getDetail(id))!.order.qrToken;
    await repository.cancel(id);

    final result = await repository.lookupByToken(token);

    expect(result.outcome, ScanOutcome.dibatalkan);
  });

  test('scan token asing tidak ditemukan', () async {
    final result = await repository.lookupByToken('TOKENASING99');
    expect(result.outcome, ScanOutcome.tidakDikenal);
    expect(result.detail, isNull);
  });

  test('nomor nota bisa dipakai saat label rusak', () async {
    final id = await createOrder();
    final nota = (await repository.getDetail(id))!.order.nomorNota;

    final result = await repository.lookupByNota(nota);

    expect(result.outcome, ScanOutcome.siap);
    expect(result.detail!.order.id, id);
  });

  test('perubahan dari scan tercatat di riwayat', () async {
    final id = await createOrder();
    await repository.advanceStatus(id, source: StatusChangeSource.scan);

    final detail = await repository.getDetail(id);
    expect(detail!.history.last.sumber, StatusChangeSource.scan);
    expect(detail.order.status, OrderStatus.diproses);
  });
}

Future<int> insertOldOrder(
  AppDatabase db,
  int customerId,
  int serviceId,
) async {
  final old = DateTime.now().toUtc().subtract(const Duration(days: 5));
  final orderId = await db
      .into(db.orders)
      .insert(
        OrdersCompanion.insert(
          nomorNota: 'LDR-OLD-001',
          qrToken: 'OLDTOKEN01',
          customerId: customerId,
          tanggalMasuk: old,
          total: 7000,
        ),
      );
  await db
      .into(db.orderItems)
      .insert(
        OrderItemsCompanion.insert(
          orderId: orderId,
          serviceId: serviceId,
          namaLayanan: 'Cuci Kering',
          qtyMilli: 1000,
          hargaSatuan: 7000,
          subtotal: 7000,
        ),
      );
  return orderId;
}
