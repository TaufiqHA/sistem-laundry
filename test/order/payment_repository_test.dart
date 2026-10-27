import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/utils/clock.dart';
import 'package:sistem_manajemen_laundry/features/customer/data/customer_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/data/order_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/data/payment_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment_method.dart';
import 'package:sistem_manajemen_laundry/features/service/data/service_repository.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

void main() {
  late AppDatabase db;
  late PaymentRepository payments;
  late OrderRepository orders;
  late CustomerRepository customers;
  late ServiceRepository services;
  late int customerId;
  late int serviceId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    payments = PaymentRepository(db);
    orders = OrderRepository(db);
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

  Future<int> createOrder({
    int custId = 0,
    int qtyMilli = 2500,
    int harga = 7000,
  }) {
    return orders.create(
      customerId: custId == 0 ? customerId : custId,
      items: [
        NewOrderItem(
          serviceId: serviceId,
          namaLayanan: 'Cuci Kering',
          qtyMilli: qtyMilli,
          hargaSatuan: harga,
          satuan: ServiceUnit.kg,
        ),
      ],
      estimasiSelesai: DateTime.now().add(const Duration(days: 2)),
    );
  }

  Future<void> pay(
    int orderId,
    int amount, {
    PaymentMethod method = PaymentMethod.tunai,
  }) {
    return payments.add(
      orderId: orderId,
      jumlah: amount,
      metode: method,
      tanggal: DateTime.now(),
    );
  }

  test('pembayaran sebagian menambah dibayar dan mengurangi piutang', () async {
    final orderId = await createOrder();

    await pay(orderId, 10000);

    final detail = await orders.getDetail(orderId);
    expect(detail!.dibayar, 10000);
    expect(detail.piutang, 7500);

    final list = await payments.listForOrder(orderId);
    expect(list, hasLength(1));
    expect(list.single.jumlah, 10000);
    expect(list.single.metode, PaymentMethod.tunai);
  });

  test('cicilan sampai lunas lalu menolak pembayaran berikutnya', () async {
    final orderId = await createOrder();

    await pay(orderId, 5000, method: PaymentMethod.transfer);
    await pay(orderId, 12500, method: PaymentMethod.qris);

    final detail = await orders.getDetail(orderId);
    expect(detail!.dibayar, 17500);
    expect(detail.piutang, 0);
    expect(detail.lunas, isTrue);
    expect(await payments.listForOrder(orderId), hasLength(2));

    await expectLater(pay(orderId, 1000), throwsA(isA<PaymentException>()));
  });

  test('menolak jumlah nol, negatif, dan melebihi sisa', () async {
    final orderId = await createOrder();

    await expectLater(pay(orderId, 0), throwsA(isA<PaymentException>()));
    await expectLater(pay(orderId, -1000), throwsA(isA<PaymentException>()));
    await expectLater(pay(orderId, 20000), throwsA(isA<PaymentException>()));

    final detail = await orders.getDetail(orderId);
    expect(detail!.dibayar, 0);
  });

  test('order yang dibatalkan tidak bisa dibayar', () async {
    final orderId = await createOrder();
    await orders.cancel(orderId);

    await expectLater(pay(orderId, 10000), throwsA(isA<PaymentException>()));
  });

  test('hapus pembayaran mengembalikan piutang', () async {
    final orderId = await createOrder();
    await pay(orderId, 10000);
    final paymentId = (await payments.listForOrder(orderId)).single.id;

    await payments.softDelete(paymentId);

    final detail = await orders.getDetail(orderId);
    expect(detail!.dibayar, 0);
    expect(detail.piutang, 17500);
    expect(await payments.listForOrder(orderId), isEmpty);

    // Baris tidak hilang dari database, hanya tidak dihitung.
    final rows = await db.select(db.payments).get();
    expect(rows, hasLength(1));
    expect(rows.single.dihapusPada, isNotNull);
  });

  test('daftar piutang mengabaikan order lunas dan batal', () async {
    final lunas = await createOrder();
    await pay(lunas, 17500);

    final batal = await createOrder();
    await orders.cancel(batal);

    await createOrder();

    final debts = await payments.debts();
    expect(debts, hasLength(1));
    expect(debts.single.customerId, customerId);
    expect(debts.single.piutang, 17500);
    expect(debts.single.jumlahOrder, 1);
    expect(debts.single.sejak, isNotNull);

    final total = await payments.totalOutstanding();
    expect(total, 17500);
  });

  Future<void> backdateOrder(int orderId, int daysAgo) async {
    final old = nowUtc().subtract(Duration(days: daysAgo));
    await (db.update(db.orders)..where((table) => table.id.equals(orderId)))
        .write(OrdersCompanion(tanggalMasuk: Value(old)));
  }

  test('piutang digabung per pelanggan dan bisa diurutkan', () async {
    final secondCustomer = await customers.create(
      nama: 'Budi',
      telepon: '081211112222',
    );

    final oldOrder = await createOrder();
    await backdateOrder(oldOrder, 10);
    final bigOrder = await createOrder(
      custId: secondCustomer,
      qtyMilli: 5000,
      harga: 10000,
    );

    final byNominal = await payments.debts(sort: DebtSort.nominal);
    expect(byNominal.map((debt) => debt.customerId), [
      secondCustomer,
      customerId,
    ]);
    expect(byNominal.first.piutang, 50000);

    final byOldest = await payments.debts(sort: DebtSort.terlama);
    expect(byOldest.first.customerId, customerId);
    expect(bigOrder, isPositive);
  });
}
