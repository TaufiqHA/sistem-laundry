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
import 'package:sistem_manajemen_laundry/features/report/data/report_repository.dart';
import 'package:sistem_manajemen_laundry/features/report/domain/report_data.dart';
import 'package:sistem_manajemen_laundry/features/service/data/service_repository.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

void main() {
  late AppDatabase db;
  late ReportRepository reports;
  late OrderRepository orders;
  late PaymentRepository payments;
  late int customerId;
  late int cuciId;
  late int selimutId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    reports = ReportRepository(db);
    orders = OrderRepository(db);
    payments = PaymentRepository(db);

    customerId = await CustomerRepository(db)
        .create(nama: 'Ibu Sari', telepon: '081234567890');
    cuciId = await ServiceRepository(db)
        .create(nama: 'Cuci Kering', satuan: ServiceUnit.kg, harga: 7000);
    selimutId = await ServiceRepository(db)
        .create(nama: 'Selimut', satuan: ServiceUnit.pcs, harga: 15000);
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> createOrder({
    required int serviceId,
    required String nama,
    required int qtyMilli,
    required int harga,
    ServiceUnit satuan = ServiceUnit.kg,
  }) {
    return orders.create(
      customerId: customerId,
      items: [
        NewOrderItem(
          serviceId: serviceId,
          namaLayanan: nama,
          qtyMilli: qtyMilli,
          hargaSatuan: harga,
          satuan: satuan,
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

  test(
    'laporan harian menghitung pemasukan, order, dan layanan terlaris',
    () async {
      final pertama = await createOrder(
        serviceId: cuciId,
        nama: 'Cuci Kering',
        qtyMilli: 2500,
        harga: 7000,
      );
      await createOrder(
        serviceId: selimutId,
        nama: 'Selimut',
        qtyMilli: 1000,
        harga: 15000,
        satuan: ServiceUnit.pcs,
      );
      await payments.add(
        orderId: pertama,
        jumlah: 10000,
        metode: PaymentMethod.tunai,
        tanggal: DateTime.now(),
      );
      await reports.addExpense(
        kategori: 'Deterjen',
        jumlah: 4000,
        tanggal: DateTime.now(),
      );

      final today = ReportRange.day(DateTime.now());
      final data = await reports.load(start: today.start, end: today.end);

      expect(data.orderCount, 2);
      expect(data.income, 10000);
      expect(data.expenseTotal, 4000);
      expect(data.profit, 6000);
      expect(data.topServices.map((s) => s.nama), ['Cuci Kering', 'Selimut']);
      expect(data.topServices.first.qtyMilli, 2500);
      expect(data.topServices.first.revenue, 17500);
      expect(data.topServices.first.satuan, ServiceUnit.kg);
      expect(data.expenses, hasLength(1));
    },
  );

  test('order batal dan pembayaran terhapus tidak dihitung', () async {
    final batal = await createOrder(
      serviceId: cuciId,
      nama: 'Cuci Kering',
      qtyMilli: 1000,
      harga: 7000,
    );
    await orders.cancel(batal);

    final orderId = await createOrder(
      serviceId: cuciId,
      nama: 'Cuci Kering',
      qtyMilli: 2000,
      harga: 7000,
    );
    final paymentId = await payments.add(
      orderId: orderId,
      jumlah: 5000,
      metode: PaymentMethod.tunai,
      tanggal: DateTime.now(),
    );
    await payments.softDelete(paymentId);

    final today = ReportRange.day(DateTime.now());
    final data = await reports.load(start: today.start, end: today.end);

    expect(data.orderCount, 1);
    expect(data.income, 0);
    expect(data.topServices, hasLength(1));
    expect(data.topServices.single.qtyMilli, 2000);
  });

  test('laporan bulanan memuat order lama dalam bulan yang sama', () async {
    final lama = await createOrder(
      serviceId: cuciId,
      nama: 'Cuci Kering',
      qtyMilli: 1000,
      harga: 7000,
    );
    await backdate(lama, 3);
    await createOrder(
      serviceId: selimutId,
      nama: 'Selimut',
      qtyMilli: 1000,
      harga: 15000,
      satuan: ServiceUnit.pcs,
    );

    final month = ReportRange.month(DateTime.now());
    final data = await reports.load(start: month.start, end: month.end);
    final today = ReportRange.day(DateTime.now());
    final daily = await reports.load(start: today.start, end: today.end);

    expect(data.orderCount, 2);
    expect(daily.orderCount, 1);
  });

  test('pengeluaran bisa ditambah dan dihapus', () async {
    final id = await reports.addExpense(
      kategori: 'Listrik',
      jumlah: 25000,
      tanggal: DateTime.now(),
      catatan: 'Bulan ini',
    );

    final today = ReportRange.day(DateTime.now());
    var data = await reports.load(start: today.start, end: today.end);
    expect(data.expenseTotal, 25000);
    expect(data.expenses.single.catatan, 'Bulan ini');

    await reports.deleteExpense(id);
    data = await reports.load(start: today.start, end: today.end);
    expect(data.expenseTotal, 0);
    expect(data.expenses, isEmpty);
  });

  test('pengeluaran di luar periode tidak ikut', () async {
    await reports.addExpense(
      kategori: 'Sewa',
      jumlah: 500000,
      tanggal: DateTime.now().subtract(const Duration(days: 3)),
    );
    await reports.addExpense(
      kategori: 'Deterjen',
      jumlah: 4000,
      tanggal: DateTime.now(),
    );

    final today = ReportRange.day(DateTime.now());
    final data = await reports.load(start: today.start, end: today.end);

    expect(data.expenseTotal, 4000);
    expect(data.expenses, hasLength(1));
  });
}
